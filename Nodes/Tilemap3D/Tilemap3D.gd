extends Node2D

var levels = {}

func _ready():
	parse_children_tilemap2D()
	connect_level_neighbors()
	#clean neighbors, remove neighbors connetions that are one directional

#Process children tilemap2D nodes and adds them to the level system
func parse_children_tilemap2D():
	for child in get_children():
		if child.get_type() == "TileMap2D":
			var level = child.get_level()
			add_level(level, child)
		else:
			print(child.get_name(), " is not a TileMap2D node")

func connect_level_neighbors():
	for level in levels:
		var tile_map2D = get_level(level)
		var unattached_neighbors = tile_map2D.get_unattached_neighbors()
		for tile_pos2D in unattached_neighbors:
			var neighbors = unattached_neighbors[tile_pos2D] 
			for neighbor_pos3D in neighbors:
				if has_tile_pos3D(neighbor_pos3D):
					tile_map2D.add_neighbor(tile_pos2D, neighbor_pos3D)
					var neighbor_tile_map2D = get_level(neighbor_pos3D.z)
					var tile_pos3D = Vector3(tile_pos2D.x, tile_pos2D.y, level)
					var neighbor_pos2D = Vector2(neighbor_pos3D.x, neighbor_pos3D.y)
					neighbor_tile_map2D.add_neighbor(neighbor_pos2D, tile_pos3D)

func add_level(level, tilemap):
	levels[int(level)] = tilemap

func get_level(level):
	return levels[int(level)]

func get_levels():
	return levels

func has_level(level):
	return levels.has(int(level))

func get_neighbors(tile_pos3D):
	var level = tile_pos3D.z
	var tile_pos2D = Vector2(tile_pos3D.x, tile_pos3D.y)
	return get_level(level).get_neighbors(tile_pos2D)

func has_tile_pos3D(tile_pos3D):
	var level = tile_pos3D.z
	if has_level(level):
		var tile_map2D = get_level(level)
		var tile_pos2D = Vector2(tile_pos3D.x, tile_pos3D.y) 
		return tile_map2D.has_tile_pos2D(tile_pos2D)
	return false

func get_tile_pos3D(tile_pos3D):
	var level = tile_pos3D.z
	var tile_map2D = get_level(level)
	var tile_pos2D = Vector2(tile_pos3D.x, tile_pos3D.y) 
	return tile_map2D.get_tile_pos2D(tile_pos2D)

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
	#print(tile_pos3D_list)
	return tile_pos3D_list

func world2D_to_map3D(tile_pos3D_list):
	var heighest_tile_pos3D
	for tile_pos3D in tile_pos3D_list:
		if heighest_tile_pos3D == null or tile_pos3D.z > heighest_tile_pos3D.z:
			heighest_tile_pos3D = tile_pos3D
	return heighest_tile_pos3D