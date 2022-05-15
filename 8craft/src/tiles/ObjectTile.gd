extends Tile

class_name ObjectTile

var _healthMax := 0;
var _dropChance := 0.0;
var _dropAmount := 1;
var _dropItem := Item.new();

func _init(name, id, collidable, doesTile, advancedConnections, connectsTo, maxHealth, dropChance, dropAmount, dropItem).(name, id, collidable, doesTile, advancedConnections, connectsTo):
	_healthMax = maxHealth;
	_dropChance = dropChance;
	_dropAmount = dropAmount;
	_dropItem = dropItem;

func GetHealthMax():
	return _healthMax;

func HasDrops():
	return _dropChance > 0;

func DropChance():
	return _dropChance;

func DropAmount():
	return _dropAmount;

func DropItem():
	return _dropItem;
