class_name Item

var _name := "Item";
var _id := "item";
var _maxStack := 10;

func _init(name = "Item", id = "item", maxStack = 10):
	_name = name;
	_id = id;
	_maxStack = maxStack;

func Name():
	return _name;

func ID():
	return _id;

func MaxStack():
	return _maxStack;

func IsStackable():
	return _maxStack != 0;

func GetSprite():
	return load("res://res/items/" + _id + ".png");
