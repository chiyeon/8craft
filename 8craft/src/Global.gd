extends Node

signal instance_player(id);
signal create_world();
signal toggle_network_setup(toggle);

var host = false;

func  _input(event):
   if event is InputEventKey:
      if event.scancode == KEY_ESCAPE:
         get_tree().quit();