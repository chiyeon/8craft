extends TileInstance

var healthCurrent := 0;

var ItemInstance = preload("res://scenes/items/ItemInstance.tscn");

func SetTile(_tile):
	healthCurrent = _tile.GetHealthMax();
	.SetTile(_tile);

func _on_HitboxArea_area_entered(area):
	if(area.is_in_group("slash")):
		healthCurrent -= 1;
	if(healthCurrent <= 0):
		if(tile.HasDrops()):
			if(randf() < tile.DropChance()):
				for _i in range(tile.DropAmount()):
					var newItem = ItemInstance.instance();
					newItem.SetItem(tile.DropItem());
					newItem.position = self.position;
					get_tree().root.add_child(newItem);
		queue_free();
