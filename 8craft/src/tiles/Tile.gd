extends Node

class_name Tile

var _name := "Tile";
var _id := "tile_id";
var _collidable = false;
var _doesTile = false;
var _advancedConnections := false;
var _connectsTo = [];

func _init(name, id, collidable, doesTile, advancedConnections, connectsTo):
	_name = name;
	_id = id;
	_collidable = collidable;
	_doesTile = doesTile;
	_advancedConnections = advancedConnections;
	_connectsTo = connectsTo;

func Name():
	return _name;

func ID():
	return _id;

func GetSprite():
	return load("res://res/tiles/" + _id + ".png")

func IsCollidable():
	return _collidable;

func DoesTile():
	return _doesTile;

func AdvancedConnections():
	return _advancedConnections;

func ConnectsTo():
	return _connectsTo;
