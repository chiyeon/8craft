extends StaticBody2D

class_name TileInstance

const tileSize = 8;

var tile;

func SetSprite(_texture):
	get_node("Sprite").texture = _texture;

func SetTile(_tile):
	tile = _tile;

	var tex = _tile.GetSprite();

	get_node("Sprite").texture = tex;
	get_node("Sprite").z_index = _tile.Layer();
	if(get_node("BottomSide")):
		get_node("BottomSide").texture = tex;
	get_node("Collision").disabled = !_tile.IsCollidable();

func SetBottomVisibility(_visible):
	if(get_node("BottomSide")):
		get_node("BottomSide").visible = _visible;

"""
Changes sprite to proper variant based on supplied object
of true/false connections in 4 directions.
"""
func Update(connections):
	if not tile.DoesTile():
		return;
	
	# basic autotiling (requires 4x4 tileset, 3x3 block, 1x3 and 3x1 longs, and 1x1 short)
	var rectPos = Vector2(tileSize, tileSize);
	var bottomRectPos = Vector2(tileSize, tileSize * 4);

	if(tile.AdvancedConnections()):
		var numTrue = 0;
		for c in connections.keys():
			numTrue += 1 if connections[c] else 0;
		if(numTrue >= 3):
			rectPos.x = tileSize * 5;

	if (connections["up"] != connections["down"]):
		if(connections["up"]):
			rectPos.y += tileSize;
		else:
			rectPos.y -= tileSize;
	elif(connections["up"] == false and connections["down"] == false):
		rectPos.y = tileSize * 3;
	
	if (connections["left"] != connections["right"]):
		if(connections["right"]):
			rectPos.x -= tileSize;
			bottomRectPos.x -= tileSize;
		else:
			rectPos.x += tileSize;
			bottomRectPos.x += tileSize;
	elif(connections["left"] == false and connections["right"] == false):
		rectPos.x = tileSize * 3;
		bottomRectPos.x = tileSize * 3;
		
	get_node("Sprite").region_rect.position = rectPos;
	if(get_node("BottomSide")):
		get_node("BottomSide").region_rect.position = bottomRectPos;
