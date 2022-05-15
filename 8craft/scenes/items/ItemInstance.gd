extends Node

var item;

func SetItem(_item):
	item = _item;
	get_node("Sprite").texture = item.GetSprite();

func PickupItem():
	return item;
