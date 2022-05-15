extends KinematicBody2D

# Movement
const UP_DIR := Vector2.UP;
export var move_speed := 30.0;
var _velocity := Vector2.ZERO;

# --- Inventory ---


# Attacking
onready var HandOrigin = $HandOrigin;

var Slash = preload("res://Slash.tscn");

func _process(delta):
	# rotate hand towards mouse
	HandOrigin.look_at(get_global_mouse_position());
	
	if(Input.is_action_just_pressed("attack")):
		var newSlash = Slash.instance();
		HandOrigin.get_node("Hand").add_child(newSlash);
		newSlash.position = Vector2.ZERO;
		newSlash.rotation_degrees = 0;
		

func _physics_process(delta):
	# move player
	var verticalInput = -(Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward"));
	var horizontalInput = -(Input.get_action_strength("move_left") - Input.get_action_strength("move_right"));
	
	_velocity.y = verticalInput * move_speed;
	_velocity.x = horizontalInput * move_speed;
	
	_velocity = move_and_slide(_velocity, UP_DIR);
