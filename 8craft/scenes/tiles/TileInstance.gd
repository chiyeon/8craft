extends StaticBody2D

class_name TileInstance

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

func Update(connections):
	if(tile.DoesTile()):
		var rectPos = Vector2(8, 8);
		if(connections["up"]):
			rectPos.y += 8;
		if(connections["down"]):
			rectPos.y -= 8;
		
		if(connections["right"]):
			rectPos.x -= 8;
		if(connections["left"]):
			rectPos.x += 8;
		
		if(connections["right"] == false and connections["left"] == false):
			rectPos.x = 24;
			if(connections["up"] and connections["down"]):
				rectPos.y = 8;
			else:
				if(connections["down"]):
					rectPos.y = 0;
				elif(connections["up"]):
					rectPos.y = 16;
		
		if(connections["up"] == false and connections["down"] == false):
			rectPos.y = 24
			
			if(connections["right"] and connections["left"]):
				rectPos.x = 8;
			else:
				if(connections["right"]):
					rectPos.x = 0;
				elif(connections["left"]):
					rectPos.x = 16;
				
		if(connections["up"] == false and connections["down"] == false and connections["left"] == false and connections["right"] == false):
			rectPos = Vector2(24, 24);
		
		var bottomRectPos = Vector2(8, 32);

		if !(connections["right"] and connections["left"]):
			if(connections["right"] == false and connections["left"] == false):
				bottomRectPos.x = 24;
			elif(connections["left"] == false):
				bottomRectPos.x = 0;
			else:
				bottomRectPos.x = 16;
			#if(connections.x == 0 and connections.y == -1):
			#	rectPos.x = 24;
		
		if(tile.AdvancedConnections()):
			if(connections["up"] and connections["down"] and connections["left"] and connections["right"]):
				rectPos.x = 40;
				rectPos.y = 8;
			elif(connections["right"] and connections["left"] and connections["down"]):
				rectPos.x = 40;
				rectPos.y = 0;
			elif(connections["right"] and connections["left"] and connections["up"]):
				rectPos.x = 40;
				rectPos.y = 16;
			elif(connections["up"] and connections["down"] and connections["right"]):
				rectPos.x = 32;
				rectPos.y = 8;
			elif(connections["up"] and connections["down"] and connections["left"]):
				rectPos.x = 48;
				rectPos.y = 8;
			
		get_node("Sprite").region_rect.position = rectPos;
		if(get_node("BottomSide")):
			get_node("BottomSide").region_rect.position = bottomRectPos;
		
