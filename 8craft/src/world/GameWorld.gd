class_name GameWorld

var world_data = [];    # world tile ids
var world_tiles = [];   # instanced nodes

var width := 0;
var height := 0;
var tileSize := 0;
var parent = null;

var TileInstance = preload("res://scenes/tiles/TileInstance.tscn");
var ObjectTileInstance = preload("res://scenes/tiles/ObjectTileInstance.tscn");

var TD = TileDatabase.new();

# Initializes a new GameWorld instance &
# fills it with empty tiles/null instances
func _init(_width, _height, _tileSize, _parent):
	# set vars
	width = _width;
	height = _height;
	tileSize = _tileSize;
	parent = _parent;
	
	# fill arrays based on world
	for i in range(4):
		world_data.append([]);
		world_tiles.append([]);
		for y in range(height):
			world_data[i].append([]);
			world_tiles[i].append([]);
			for _x in range(width):
				world_data[i][y].append(TD.EMPTY);
				world_tiles[i][y].append(null);

# sets data & spawns instance of tile
# only use on something OTHER than EMPTY
func SetTile(_tile, _pos):
	if(_tile != TD.EMPTY):
		var tileRef = TD.tiles[_tile];
		var tileLayer = tileRef.Layer();

		if(_tile == GetTile(_pos.x, _pos.y, tileLayer)):
			return false;

		# set data, spawn tile
		SetTileData(_tile, _pos);
		_SpawnTile(_pos, tileLayer);
		# update self & surrounding tiles
		_UpdateTile(_pos, tileLayer);
		for tilePos in _getSurroundingTiles(_pos):
			_UpdateTile(tilePos, tileLayer);
		return true;
	return false;

# sets the tile to EMPTY and removes instance
func RemoveTile(_pos, _layer):
	if(_layer == TD.LAYER_GROUND):
		SetTile(TD.WATER, _pos);
	else:
		world_data[_layer][_pos.y][_pos.x] = TD.EMPTY;
		_SpawnTile(_pos, _layer);
		for tilePos in _getSurroundingTiles(_pos):
			_UpdateTile(tilePos, _layer);

# sets the data of a tile only
func SetTileData(_tile, _pos):
	var tileRef = TD.tiles[_tile];

	world_data[tileRef.Layer()][_pos.y][_pos.x] = _tile;

func GetTile(_x, _y, _layer):
	return world_data[_layer][_y][_x];

# spawn tile based on world data
# destroys instanced tile if one exists
func _SpawnTile(_pos, _layer):
	var tileID = world_data[_layer][_pos.y][_pos.x]

	# destroy tile if one exists
	if(world_tiles[_layer][_pos.y][_pos.x] != null):
		world_tiles[_layer][_pos.y][_pos.x].queue_free();
		world_tiles[_layer][_pos.y][_pos.x] = null;

	if(tileID != TD.EMPTY):
		# get reference to tile object from database
		var tileRef = TD.tiles[tileID];

		# instance tiles
		var newTile = (ObjectTileInstance if tileRef is ObjectTile else TileInstance).instance();
		#newTile.z_index = tileRef.Layer();
		newTile.SetTile(tileRef);
		newTile.position = Vector2(_pos.x * tileSize, _pos.y * tileSize);
		parent.add_child(newTile);

		# add to tiles array
		world_tiles[_layer][_pos.y][_pos.x] = newTile;

func SpawnWorld():
	for l in range(4):
		for y in range(height):
			for x in range(width):
				_SpawnTile(Vector2(x, y), l);

func _UpdateTile(_pos, _layer):
	if(world_data[_layer][_pos.y][_pos.x] == TD.EMPTY):
		return;
	
	var y = _pos.y;
	var x = _pos.x;

	var thisTile = TD.tiles[world_data[_layer][y][x]];

	var connections = {
	  "up": false,
	  "down": false,
	  "right": false,
	  "left": false,
	}
	
	if(x != 0):
		connections["left"] = thisTile.ConnectsTo().has(world_data[_layer][y][x-1]);
	if(x != world_data[_layer][0].size() - 1):
			connections["right"] = thisTile.ConnectsTo().has(world_data[_layer][y][x+1]);
	if(y != 0):
			connections["up"] = thisTile.ConnectsTo().has(world_data[_layer][y-1][x]);
	if(y != world_data[_layer].size() - 1):
			connections["down"] = thisTile.ConnectsTo().has(world_data[_layer][y+1][x]);
	
	world_tiles[_layer][y][x].Update(connections, tileSize);

	if(thisTile.ID() != TD.WATER and thisTile.Layer() == TD.LAYER_GROUND):
		world_tiles[_layer][y][x].SetBottomVisibility(world_data[_layer][y+1][x] == TD.WATER || world_data[_layer][y+1][x] == TD.EMPTY);

func _UpdateWorldLayer(_layer):
	for y in range(height):
		for x in range(width):
			if(world_data[_layer][y][x] != TD.EMPTY):
				_UpdateTile(Vector2(x, y), _layer);

func UpdateWorld():
	for l in range(3):
		_UpdateWorldLayer(l);

func _getSurroundingTiles(_pos):
	var tiles = [];
	if(_pos.y != 0):
		tiles.append(Vector2(_pos.x, _pos.y - 1));
	if(_pos.y != height - 1):
		tiles.append(Vector2(_pos.x, _pos.y + 1));
	if(_pos.x != 0):
		tiles.append(Vector2(_pos.x - 1, _pos.y));
	if(_pos.x != width - 1):
		tiles.append(Vector2(_pos.x + 1, _pos.y));
	
	return tiles;
