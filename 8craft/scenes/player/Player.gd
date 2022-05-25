extends KinematicBody2D

# Movement
const UP_DIR := Vector2.UP;
export var move_speed := 30.0;
var _velocity := Vector2.ZERO;

# camera
export(NodePath) onready var PlayerCamera = get_node(PlayerCamera) as Camera;
export(NodePath) onready var NetworkTickRate = get_node(NetworkTickRate) as Timer;
export(NodePath) onready var MovementTween = get_node(MovementTween) as Tween;

# --- Inventory ---
var tiles = [
	"walls",
	"water",
	"grass",
	"dirt",
	"sand",
	"tree",
	"walls",
	"floor",
	"flower_red",
	"flower_yellow"
]
var currTile = 0;

# Attacking
onready var HandOrigin = $HandOrigin;

var Slash = preload("res://Slash.tscn");

# network stuff
var puppet_position = Vector2();
var puppet_velocity = Vector2();

func _ready():
	if is_network_master():
		_ChangeCurrTile(0);
		get_node("Camera2D").current = true;
	else:
		get_node("Camera2D").visible = false;
	
func _process(_delta):
	if is_network_master():
		# rotate hand towards mouse
		HandOrigin.look_at(get_global_mouse_position());
		
		if(Input.is_action_just_pressed("attack")):
			"""
			var newSlash = Slash.instance();
			HandOrigin.get_node("Hand").add_child(newSlash);
			newSlash.position = Vector2.ZERO;
			newSlash.rotation_degrees = 0;
			"""
			var pos = Vector2(floor(get_global_mouse_position().x / 8 + 0.5), floor(get_global_mouse_position().y / 8 + 0.5));
			WorldGenerator.AttemptRemoveTile(pos);
			rpc("edit_world", "EMPTY", pos);
		elif(Input.is_action_just_pressed("interact")):
			var pos = Vector2(floor(get_global_mouse_position().x / 8 + 0.5), floor(get_global_mouse_position().y / 8 + 0.5));

			WorldGenerator.AttemptPlaceTile(tiles[currTile], pos);
			rpc("edit_world", tiles[currTile], pos);
		
		if(Input.is_action_just_released("scroll_up")):
			_ChangeCurrTile(1);
		elif(Input.is_action_just_released("scroll_down")):
			_ChangeCurrTile(-1);

func _ChangeCurrTile(dir):
	currTile += dir;
	if(currTile < 0):
		currTile = len(tiles) - 1;
	elif(currTile >= len(tiles)):
		currTile = 0;
	
	get_node("Camera2D/BlockLabel").text = tiles[currTile];

func _physics_process(_delta):
	if is_network_master():
		# move player
		var verticalInput = -(Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward"));
		var horizontalInput = -(Input.get_action_strength("move_left") - Input.get_action_strength("move_right"));
		
		_velocity.y = verticalInput * move_speed;
		_velocity.x = horizontalInput * move_speed;
		
		_velocity = move_and_slide(_velocity, UP_DIR);

puppet func update_state(_position):
	puppet_position = _position;

	MovementTween.interpolate_property(self, "global_position", global_position, _position, 0.1);
	MovementTween.start();

func _on_NetworkTickRate_timeout():
	if is_network_master():
		rpc_unreliable("update_state", global_position);
	else:
		NetworkTickRate.stop();

puppet func edit_world(_tile, _pos):
	if(_tile == "EMPTY"):
		WorldGenerator.AttemptRemoveTile(_pos);
	else:
		WorldGenerator.AttemptPlaceTile(_tile, _pos);
