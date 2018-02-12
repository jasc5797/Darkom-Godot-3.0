tool
extends TileMap

export(int) var level = 0 setget set_level, get_level

#Valid/Walkable tiles
var tile_map = {}

var unattached_neighbors = {}

func _ready():
	initialize_tile_map()

func initialize_tile_map():
	for tile_pos2D in get_used_cells():
		tile_map[tile_pos2D] = []
	for tile_pos2D in tile_map.keys():
		var tile_id = get_cellv(tile_pos2D)
		var tile_name = tile_set.tile_get_name(tile_id)
		var open_index = tile_name.find("(")
		var close_index = tile_name.find(")")
		var tile_info = Array(tile_name.substr(open_index + 1, close_index - open_index - 1).split(","))
		set_neigbors_on_level(tile_pos2D, tile_info)
		set_unattached_neighbors(tile_pos2D, tile_info)

func set_neigbors_on_level(tile_pos2D, tile_info):
	var tile_pos3D = Vector3(tile_pos2D.x, tile_pos2D.y, level)
	var neighbors = []
	if tile_info.has("N") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(0, -1)):
			neighbors.append(tile_pos3D + Vector3(0, -1, 0))
	if tile_info.has("S") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(0, 1)):
			neighbors.append(tile_pos3D + Vector3(0, 1, 0))
	if tile_info.has("E") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(-1, 0)):
			neighbors.append(tile_pos3D + Vector3(-1, 0, 0))
	if tile_info.has("W") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(1, 0)):
			neighbors.append(tile_pos3D + Vector3(1, 0, 0))
	for neighbor in neighbors:
		tile_map[tile_pos2D].append(neighbor)

func set_unattached_neighbors(tile_pos2D, tile_info):
	var tile_pos3D = Vector3(tile_pos2D.x, tile_pos2D.y, level)
	var neighbors_to_check = []
	for info in tile_info:
		var neighbor = Vector2(0, 0)
		if info.find("D") >= 0:
			if info.find("N") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(0, -1, -1))
			if info.find("S") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(0, 1, -1))
			if info.find("E") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(-1, 0, -1))
			if info.find("W") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(1, 0, -1))
		if info.find("U") >= 0:
			if info.find("N") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(0, -1, 1))
			if info.find("S") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(0, 1, 1))
			if info.find("E") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(-1, 0, 1))
			if info.find("W") >= 0 or info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(1, 0, 1))
	if not neighbors_to_check.empty():
		unattached_neighbors[tile_pos2D] = neighbors_to_check
	

func get_unattached_neighbors():
	

func get_neighbors(tile_pos2D):
	return tile_map[tile_pos2D]

func set_level(new_level):
	if level != null:
		level = new_level
		set_position(-Vector2(0, level * cell_size.y))
		#Trying to get a z level between each tilemap by multiplying the level by two 
		z_index = level * 2

func get_level():
	return level

func has_tile_pos2D(tile_pos2D):
	return tile_map.has(tile_pos2D)

func get_tile_pos2D(tile_pos2D):
	return tile_map[tile_pos2D]

func get_tile_map():
	return tile_map

func get_type():
	return "TileMap2D"

#Standard TileMap.world_to_map does not take into account the offset that is caused
#by setting the level
func world_to_map2D(world_pos2D):
	var tile_pos = world_to_map(world_pos2D)
	return tile_pos + get_level_offset()

func get_level_offset():
	return Vector2(level, level)
