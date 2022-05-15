extends Node2D

const EMPTY = "empty";
const WATER = "water";
const GRASS = "grass";
const DIRT = "dirt";
const SAND = "sand";
const TREE = "tree";
const WALL = "walls";
const FLOOR = "floor";

const WIDTH = 100;
const HEIGHT = 100;
const TILE_SIZE = 8;

var noise = OpenSimplexNoise.new();
var rng = RandomNumberGenerator.new();

var water = [];
var world_0 = [];	# dirt & water layer					z-index = 0
var world_1 = [];	# grass & sand etc					z-index = 1;
var world_2 = [];	# trees & objects etc				z-index = 4;
var world_3 = []; # below objects, floor tiles etc z-index = 2;

var world_0_Tiles = [];
var world_1_Tiles = [];
var world_2_Tiles = [];
var world_3_Tiles = [];

var ItemDatabase = {
	"wood": Item.new("Wood", "wood", 10)
}

var TileDatabase = {
	GRASS: Tile.new("Grass", "grass", false, true, false, [GRASS, DIRT, SAND]),
	WATER: Tile.new("Water", "water", true, false, false, []),
	DIRT: Tile.new("Dirt", "dirt", false, true, false, [GRASS, DIRT, SAND]),
	SAND: Tile.new("Sand", "sand", false, true, false, [SAND, GRASS]),
	TREE: ObjectTile.new("Tree", "tree", true, false, false, [], 30, 1, 1, ItemDatabase["wood"]),
	WALL: ObjectTile.new("Wall", "walls", true, true, true, [WALL], 100, 0, 0, null),
	FLOOR: Tile.new("Floor", "floor", false, true, false, [FLOOR])
}

var TileInstance = preload("res://scenes/tiles/TileInstance.tscn")
var ObjectTileInstance = preload("res://scenes/tiles/ObjectTileInstance.tscn");

func _ready():
	var _date = OS.get_date();
	var _time = OS.get_time();
	
	var _seed = _date.year + _date.month + _date.day + _time.hour + _time.minute + _time.second;
	
	noise.seed = _seed;
	rng.seed = _seed;
	
	noise.octaves = 5;
	noise.period = 32;
	
	# set up random world
	for y in range(HEIGHT):
		world_0.append([])
		water.append([]);
		for x in range(WIDTH):
			water[y].append(WATER);
			world_0[y].append(WATER if rng.randi_range(0, 1) < 0.5 else DIRT);
			
			if(y < 2 or x < 2 or y > HEIGHT - 3 or x > WIDTH - 3):
				world_0[y][x] = WATER;
	
	for _i in range(3):
		smoothWorld(world_0);
	
	#repaint(world_0, world_0_Tiles, 0);
	#updateWorld(world_0, world_0, world_0_Tiles);

	world_1 = getBiomes(world_0);
	repaint(world_1, world_1_Tiles, 1);
	updateWorld(world_1, world_1_Tiles);
	
	world_2 = getTrees(world_1)
	repaintObjects(world_2, world_2_Tiles, 4);

	world_3 = getEmptyWorld();
	repaint(world_3, world_3_Tiles, 3);

func _process(_delta):
	if(Input.is_action_just_pressed("attack")):
		var pos = Vector2(floor(get_global_mouse_position().x / TILE_SIZE + 0.5), floor(get_global_mouse_position().y / TILE_SIZE + 0.5));
		PlaceTile(FLOOR, world_3, world_3_Tiles, 2, pos, TileInstance);
	elif(Input.is_action_just_pressed("interact")):
		var pos = Vector2(floor(get_global_mouse_position().x / TILE_SIZE + 0.5), floor(get_global_mouse_position().y / TILE_SIZE + 0.5));
		PlaceTile(WALL, world_2, world_2_Tiles, 4, pos, ObjectTileInstance);

func PlaceTile(_tile, _world, _worldTiles, _z, _pos, _TileInstance):
	_world[_pos.y][_pos.x] = _tile;
	repaintTile(_world, _worldTiles, _z, _pos, _TileInstance);
	updateTile(_world, _worldTiles, _pos.x, _pos.y);
	for t in getSurroundingTiles(_pos.x, _pos.y, _world):
		updateTile(_world, _worldTiles, t.x, t.y);

func repaint(_world, _worldTiles, _z):
	for y in range(_world.size()):
		_worldTiles.append([]);
		for x in range(_world[0].size()):
			_worldTiles[y].append(null);
			if(_world[y][x] != EMPTY):
				repaintTile(_world, _worldTiles, _z, Vector2(x, y), TileInstance);

func repaintTile(_world, _worldTiles, _z, _pos, _tileInstance):
	if(_worldTiles[_pos.y][_pos.x] != null):
		_worldTiles[_pos.y][_pos.x].queue_free();
		_worldTiles[_pos.y][_pos.x] = null;

	if(_world[_pos.y][_pos.x] == EMPTY):
		return;

	var newTile = _tileInstance.instance();
	newTile.z_index = _z;
	newTile.SetTile(TileDatabase[_world[_pos.y][_pos.x]]);
	newTile.position = Vector2(_pos.x * TILE_SIZE, _pos.y * TILE_SIZE);
	add_child(newTile);
	_worldTiles[_pos.y][_pos.x] = newTile;

func repaintObjects(_world, _worldTiles, _z):
	for y in range(_world.size()):
		_worldTiles.append([]);
		for x in range(_world[0].size()):
			if(_world[y][x] != EMPTY):
				var newTile = ObjectTileInstance.instance();
				newTile.z_index = _z;
				newTile.SetTile(TileDatabase[_world[y][x]]);
				newTile.position = Vector2(x * TILE_SIZE, y * TILE_SIZE);
				add_child(newTile);
				_worldTiles[y].append(newTile);
			else:
				_worldTiles[y].append(null);

func getTrees(_world):
	var trees = [];
	for y in range(_world.size()):
		trees.append([]);
		for x in range(_world[0].size()):
			if(_world[y][x] == GRASS and randf() < 0.05):
				trees[y].append(TREE);
			else:
				trees[y].append(EMPTY);
	return trees;

			
func smoothWorld(_world):
	for y in range(_world.size()):
		for x in range(_world[0].size()):
			if(_world[y][x] != WATER):
				if(getAmountSurrounding(_world, x, y, WATER) >= 6):
					_world[y][x] = WATER;
			else:
				if(getAmountSurrounding(_world, x, y, WATER) <= 4):
					_world[y][x] = DIRT;

func setBiomes(_world):
	for y in range(_world.size()):
		for x in range(_world.size()):
			var b = noise.get_noise_2d(x, y)
			if(_world[y][x] != EMPTY && _world[y][x] != WATER):
				if(b > 0.15):
					_world[y][x] = DIRT;

func getBiomes(_world):
	var newWorld = []
	for y in range(_world.size()):
		newWorld.append([])
		for x in range(_world[0].size()):
			newWorld[y].append(WATER);
			
			var b = noise.get_noise_2d(x, y)
			if(_world[y][x] != EMPTY && _world[y][x] != WATER):
				if(b > 0.15):
					newWorld[y][x] = SAND;
				else:
					newWorld[y][x] = GRASS;
	return newWorld;

func getEmptyWorld():
	var new = [];
	for y in range(HEIGHT):
		new.append([]);
		for _x in range(WIDTH):
			new[y].append(EMPTY);
	return new;

func updateTile(_world, _tiles, x, y):
	if(_world[y][x] == EMPTY):
		return;

	var thisTile = TileDatabase[_world[y][x]];

	var connections = {
		"up": false,
		"down": false,
		"right": false,
		"left": false
	}
	
	if(x != 0):
		if(thisTile.ConnectsTo().has(_world[y][x-1])):
			connections["left"] = true;
	if(x != _world[0].size() - 1):
		if(thisTile.ConnectsTo().has(_world[y][x+1])):
			connections["right"] = true;
	if(y != 0):
		if(thisTile.ConnectsTo().has(_world[y-1][x])):
			connections["up"] = true;
	if(y != _world.size() - 1):
		if(thisTile.ConnectsTo().has(_world[y+1][x])):
			connections["down"] = true;
	
	_tiles[y][x].Update(connections);

	if(thisTile.ID() != WATER):
		_tiles[y][x].SetBottomVisibility(_world[y+1][x] == WATER || _world[y+1][x] == EMPTY);
		

func updateWorld(_world, _tiles):
	for y in range(_world.size()):
		for x in range(_world[0].size()):
			if(_world[y][x] != EMPTY):
				updateTile(_world, _tiles, x, y);

func getSurroundingTiles(x, y, _world):
	var tiles = [];
	if(y != 0):
		tiles.append(Vector2(x, y - 1));
	if(y != _world.size() - 1):
		tiles.append(Vector2(x, y + 1));
	if(x != 0):
		tiles.append(Vector2(x - 1, y));
	if(x != _world.size() - 1):
		tiles.append(Vector2(x + 1, y));
	
	return tiles;
		

func getAmountSurrounding(_world, posX, posY, search):
	var count = 0;
	for _x in range(3):
		var x = posX - (_x - 1);
		for _y in range(3):
			var y = posY - (_y - 1);
			if(x >= 0 and y >= 0 and x < _world[0].size() and y < _world.size()):
				if(_world[y][x] == search):
					count += 1;
			else:
				count += 1;
	return count;
