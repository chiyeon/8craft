class_name TileDatabase

const EMPTY = "empty";
const WATER = "water";
const GRASS = "grass";
const DIRT = "dirt";
const SAND = "sand";
const TREE = "tree";
const WALL = "walls";
const WALL_WOOD = "walls_wood";
const FLOOR = "floor";
const FLOWER_RED = "flower_red";
const FLOWER_YELLOW = "flower_yellow";
const CACTUS = "cactus";

const LAYER_GROUND = 0;
const LAYER_FLOOR = 1;
const LAYER_OBJECTS = 2;
const test = 3;

var tiles = {
	GRASS: Tile.new("Grass", "grass", LAYER_GROUND, false, true, false, [GRASS]),
	WATER: Tile.new("Water", "water", LAYER_GROUND, true, false, false, [WATER]),
	DIRT: Tile.new("Dirt", "dirt", LAYER_GROUND, false, true, false, [DIRT]),
	SAND: Tile.new("Sand", "sand", LAYER_GROUND, false, true, false, [SAND]),
	TREE: ObjectTile.new("Tree", "tree", LAYER_OBJECTS, true, false, false, [], 30, 1, 1, null, Vector2(8, 16), Vector2(0, -4)),
	WALL: ObjectTile.new("Wall", "walls", LAYER_OBJECTS, true, true, true, [WALL, WALL_WOOD], 100, 0, 0, null, Vector2(8, 8), Vector2.ZERO),
	WALL_WOOD: ObjectTile.new("Wooden Wall", WALL_WOOD, LAYER_OBJECTS, true, true, true, [WALL_WOOD, WALL], 100, 0, 0, null, Vector2(8, 8), Vector2.ZERO),
	FLOOR: Tile.new("Floor", "floor", LAYER_FLOOR, false, true, false, [FLOOR]),
	FLOWER_RED: ObjectTile.new("Red Flower", "flower_red", LAYER_FLOOR, false, false, false, [], 1, 0, 0, null, Vector2(8, 8), Vector2.ZERO),
	FLOWER_YELLOW: ObjectTile.new("Yellow Flower", "flower_yellow", LAYER_FLOOR, false, false, false, [], 1, 0, 0, null, Vector2(8, 8), Vector2.ZERO),
	CACTUS: ObjectTile.new("Cactus", "cactus", LAYER_OBJECTS, true, false, false, [], 3, 0, 0, null, Vector2(8, 16), Vector2(0, -4))
}

func _init():
	pass;