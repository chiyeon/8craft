extends Node2D

const WIDTH = 100;
const HEIGHT = 100;
const TILE_SIZE = 8;

var noise = OpenSimplexNoise.new();
var rng = RandomNumberGenerator.new();

var TD = TileDatabase.new();
var world = GameWorld.new(WIDTH, HEIGHT, TILE_SIZE, self);

func CreateWorld():
	var _date = OS.get_date();
	var _time = OS.get_time();
	
	var _seed = _date.year + _date.month + _date.day + _time.hour + _time.minute + _time.second;
	#_seed = "MonkeyLand".to_int();
	
	noise.seed = _seed;
	rng.seed = _seed;
	
	noise.octaves = 5;
	noise.period = 32;
	
	# set up random world
	for y in range(HEIGHT):
		for x in range(WIDTH):
			var tile = TD.WATER if rng.randi_range(0, 1) < 0.5 else TD.DIRT;

			if(y < 2 or x < 2 or y > HEIGHT - 3 or x > WIDTH - 3):
				tile = TD.WATER;

			world.SetTileData(tile, Vector2(x, y));
	
	for _i in range(3):
		smoothWorld(world, 0);

	setBiomes(world);
	setTrees(world);

	world.SpawnWorld();
	world.UpdateWorld();

	return world.world_data;

func SetWorldData(_data):
	world.world_data = _data;
	world.SpawnWorld();
	world.UpdateWorld();

func AttemptPlaceTile(_tile, _pos):
	return world.SetTile(_tile, _pos);

func AttemptRemoveTile(_pos):
	for layer in range(3, -1, -1):
		if(world.GetTile(_pos.x, _pos.y, layer) != TD.EMPTY):
			world.RemoveTile(_pos, layer);
			return true;

func setTrees(_world):
	for y in range(_world.height):
		for x in range(_world.width):
			if(_world.GetTile(x, y, 0) == TD.GRASS):
				var c = randf()
				if(c < 0.03):
					_world.SetTileData(TD.TREE, Vector2(x, y));
				elif(c < 0.1):
					_world.SetTileData(TD.FLOWER_RED, Vector2(x, y));
				elif(c < 0.15):
					_world.SetTileData(TD.FLOWER_YELLOW, Vector2(x, y));
			elif(_world.GetTile(x, y, 0) == TD.SAND):
				var c = randf()
				if(c < 0.026):
					_world.SetTileData(TD.CACTUS, Vector2(x, y));
	
func smoothWorld(_world, _layer):
	for y in range(_world.height):
		for x in range(_world.width):
			if(_world.GetTile(x, y, _layer) != TD.WATER):
				if(getAmountSurrounding(_world, x, y, _layer, TD.WATER) >= 6):
					_world.SetTileData(TD.WATER, Vector2(x, y));
			else:
				if(getAmountSurrounding(_world, x, y, _layer, TD.WATER) <= 4):
					_world.SetTileData(TD.DIRT, Vector2(x, y));

func setBiomes(_world):
	for y in range(_world.height):
		for x in range(_world.width):
			var b = noise.get_noise_2d(x, y)

			if(_world.GetTile(x, y, 0) != TD.WATER):
				if(b > 0.15):
					_world.SetTileData(TD.SAND, Vector2(x, y));
				else:
					_world.SetTileData(TD.GRASS, Vector2(x, y));

func getAmountSurrounding(_world, posX, posY, _layer, search):
	var count = 0;
	for _x in range(3):
		var x = posX - (_x - 1);
		for _y in range(3):
			var y = posY - (_y - 1);
			if(x >= 0 and y >= 0 and x < _world.width and y < _world.height):
				if(_world.GetTile(x, y, _layer) == search):
					count += 1;
			else:
				count += 1;
	return count;
