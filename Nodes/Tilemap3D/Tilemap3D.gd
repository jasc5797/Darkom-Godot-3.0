extends Node2D

var levels = {}

func _ready():
	parse_children()

func parse_children():
	for child in get_children():
		if child.get_type() == "TileMap2D":
			var level = child.get_level()
			add_level(level, child)
		else:
			print(child.get_name(), " is not a TileMap2D node")

func add_level(level, tilemap):
	levels[level] = tilemap

func get_level(level):
	return levels[int(level)]

func get_levels():
	return levels

func has_level(level):
	levels.has(level);

func has_tile_pos3D(tile_pos3D):
	var level = tile_pos3D.z
	if has_level(level):
		var tile_map2D = get_level(level)
		var tile_pos2D = Vector2(tile_pos3D.x, tile_pos3D.y) 
		return tile_map2D.has_tile_pos2D(tile_pos2D)
	return false

func world_to_map3D(pos3D):
	var tilemap2D = get_level(pos3D.z)
	var tile_pos2D = tilemap2D.world_to_map(Vector2(pos3D.x, pos3D.y))
	return Vector2(tile_pos2D.x, tile_pos2D.y, pos3D.z)