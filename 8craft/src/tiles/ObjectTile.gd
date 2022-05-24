extends Tile

class_name ObjectTile

var _healthMax := 0;
var _dropChance := 0.0;
var _dropAmount := 1;
var _dropItem := Item.new();
var _spriteRect := Vector2.ZERO;
var _spritePos := Vector2.ZERO;

func _init(name, id, layer, collidable, doesTile, advancedConnections, connectsTo, maxHealth, dropChance, dropAmount, dropItem, spriteRect, spritePos).(name, id, layer, collidable, doesTile, advancedConnections, connectsTo):
	_healthMax = maxHealth;
	_dropChance = dropChance;
	_dropAmount = dropAmount;
	_dropItem = dropItem;
	_spriteRect = spriteRect;
	_spritePos = spritePos;

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

func SpriteSize():
	return _spriteRect;

func SpritePos():
	return _spritePos;