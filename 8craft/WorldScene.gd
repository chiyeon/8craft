extends Node

var player = preload("res://scenes/player/Player.tscn");

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected");
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected");

	Global.connect("instance_player", self, "_instance_player");
	
	Global.connect("create_world", self, "_create_world");

	if get_tree().network_peer != null:
		Global.emit_signal("toggle_network_setup", false);

func _instance_player(id):
	var player_instance = player.instance();
	player_instance.set_network_master(id);
	player_instance.name = str(id);

	add_child(player_instance);

func _player_connected(id):
	print("Player " + str(id) + " has connected");

	if(is_network_master() and Global.host):
		rpc_id(id, "load_world", WorldGenerator.world.world_data);

	_instance_player(id);

func _player_disconnected(id):
	print("Player " + str(id) + " has disconnected");

	if has_node(str(id)):
		get_node(str(id)).queue_free();

func _create_world():
	var world = WorldGenerator.CreateWorld();
	rpc("load_world", world);

puppet func load_world(_worldData):
	print("loading world");
	WorldGenerator.SetWorldData(_worldData);