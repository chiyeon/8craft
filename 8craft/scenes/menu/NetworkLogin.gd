extends Control

const World = preload("res://World.tscn");

func _ready():
	Global.connect("toggle_network_setup", self, "_toggle_network_setup");

func _on_JoinButton_pressed():
	Network.join_server();
	hide();
	LoadWorld();

func _on_HostButton_pressed():
	Network.create_server();
	hide();
	LoadWorld();
	Global.host = true;
	Global.emit_signal("create_world");

func _on_LineEdit_text_changed(new_text:String):
	Network.ip_address = new_text;

func LoadWorld():
	var newWorld = World.instance();
	add_child(newWorld);

	Global.emit_signal("instance_player", get_tree().get_network_unique_id());

func _toggle_network_setup(toggle):
	visible = toggle;