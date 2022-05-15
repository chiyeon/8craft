class_name InventoryItem

var item;
var amount;

func _init(_item, _amount):
	item = _item;
	amount = _amount;

func Add(_amount):
	var remaining = _amount - (item.MaxStack() - amount);
	
	# there are extras
	if(remaining > 0):
		amount = item.MaxStack();
		return remaining;
	else:
		return 0

func HasItem():
	return amount != 0;
