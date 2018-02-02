extends Node2D

var levels = {}

func _ready():
	parse_children_tilemap2Ds()

#Process children tilemap2D nodes and adds them to the level system
func parse_children_tilemap2Ds():
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

func world_to_map3D(pos_3D):
	var tile_map2D = get_level(pos_3D.z)
	var tile_pos2D = tile_map2D.world_to_map2D(Vector2(pos_3D.x, pos_3D.y))
	return Vector2(tile_pos2D.x, tile_pos2D.y, pos_3D.z)


#returns all the possible tile_pos2D at a given world_pos2
func world2D_to_map3D_list(world_pos2D):
	var tile_pos3D_list = []
	for level in get_levels():
		var tile_map2D = get_level(level)
		var tile_pos2D = tile_map2D.world_to_map2D(world_pos2D)
		if tile_map2D.has_tile_pos2D(tile_pos2D):
			tile_pos3D_list.append(Vector3(tile_pos2D.x, tile_pos2D.y, tile_map2D.get_level()))
	print(tile_pos3D_list)
	return tile_pos3D_list

func world2D_to_map3D(tile_pos3D_list):
	var heighest_tile_pos3D
	for tile_pos3D in tile_pos3D_list:
		if heighest_tile_pos3D == null or tile_pos3D.z > heighest_tile_pos3D.z:
			heighest_tile_pos3D = tile_pos3D
	return heighest_tile_pos3D