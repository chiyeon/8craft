class_name Inventory

var _items := [];
var _maxItems = 15;

func _init(maxItems):
	_maxItems = maxItems;
	
	for i in range(_maxItems):
		_items.append(InventoryItem.new(null, 0));
"""
func AddItem(item, amount):
	for i in range(_maxItems):
		# first see if is filled slot
		if(_items[i].HasItem()):
			# item exists in inventory, add to count
			if(_items[i].item == item):
				# if count is able to fit, just add
				if(_items[i].Add(amount) > 0):
			"""	
