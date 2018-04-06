tool
extends TileMap

export(int) var level = 0 setget set_level, get_level

#Valid/Walkable tiles
var tile_map = {}

var unattached_neighbors = {}

func _ready():
	if Engine.is_editor_hint():
		#self.set_self_modulate(Color(1, 1, 1, 0.5))
		#update()
		pass
	initialize_tile_map()

func _draw():
	#if Engine.is_editor_hint():
	if false:
		for tile_pos2D in tile_map:
			draw_string($Label.get_font("font"), map_to_world(tile_pos2D), String(tile_pos2D), $Label.get_color("font_color")) 


func initialize_tile_map():
	for tile_pos2D in get_used_cells():
		var tile_id = get_cellv(tile_pos2D)
		var tile_name = tile_set.tile_get_name(tile_id)
		var open_index = tile_name.find("(")
		var close_index = tile_name.find(")")
		if open_index >= 0 and close_index >= 0:
			tile_map[tile_pos2D] = []
	for tile_pos2D in get_used_cells():
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
	if tile_info.has("W") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(-1, 0)):
			neighbors.append(tile_pos3D + Vector3(-1, 0, 0))
	if tile_info.has("E") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(1, 0)):
			neighbors.append(tile_pos3D + Vector3(1, 0, 0))
	if tile_info.has("NE") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(1, -1)):
			neighbors.append(tile_pos3D + Vector3(1, -1, 0))
	if tile_info.has("NW") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(-1, -1)):
			neighbors.append(tile_pos3D + Vector3(-1, -1, 0))
	if tile_info.has("SE") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(1, 1)):
			neighbors.append(tile_pos3D + Vector3(1, 1, 0))
	if tile_info.has("SW") or tile_info.has("A"):
		if has_tile_pos2D(tile_pos2D + Vector2(-1, 1)):
			neighbors.append(tile_pos3D + Vector3(-1, 1, 0))
	for neighbor in neighbors:
		tile_map[tile_pos2D].append(neighbor)

func set_unattached_neighbors(tile_pos2D, tile_info):
	var tile_pos3D = Vector3(tile_pos2D.x, tile_pos2D.y, level)
	var neighbors_to_check = []
	for info in tile_info:
		if info.find("D") >= 0:
			var offset = Vector3(0, 0, -1)
			if info.find("N") >= 0:
				offset += Vector3(0, -1, 0)
			if info.find("S") >= 0:
				offset +=tile_pos3D + Vector3(0, 1, 0)
			if info.find("W") >= 0:
				offset += Vector3(-1, 0, 0)
			if info.find("E") >= 0:
				offset += Vector3(1, 0, 0)
			if offset != Vector3(0, 0, -1):
				neighbors_to_check.append(tile_pos3D + offset)
			if info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(1, 0, -1))
				neighbors_to_check.append(tile_pos3D + Vector3(-1, 0, -1))
				neighbors_to_check.append(tile_pos3D + Vector3(0, 1, -1))
				neighbors_to_check.append(tile_pos3D + Vector3(0, -1, -1))
		if info.find("U") >= 0:
			var offset = Vector3(0, 0, 1)
			if info.find("N") >= 0:
				offset += Vector3(0, -1, 0)
			if info.find("S") >= 0:
				offset +=tile_pos3D + Vector3(0, 1, 0)
			if info.find("W") >= 0:
				offset += Vector3(-1, 0, 0)
			if info.find("E") >= 0:
				offset += Vector3(1, 0, 0)
			if offset != Vector3(0, 0, 1):
				neighbors_to_check.append(tile_pos3D + offset)
			if info.find("A") >= 0:
				neighbors_to_check.append(tile_pos3D + Vector3(1, 0, 1))
				neighbors_to_check.append(tile_pos3D + Vector3(-1, 0, 1))
				neighbors_to_check.append(tile_pos3D + Vector3(0, 1, 1))
				neighbors_to_check.append(tile_pos3D + Vector3(0, -1, 1))
	if not neighbors_to_check.empty():
		unattached_neighbors[tile_pos2D] = neighbors_to_check


#used to clean var that arent need after initialization
func clean():
	unattached_neighbors.clear()

func get_unattached_neighbors():
	return unattached_neighbors

func add_neighbor(tile_pos2D, tile_pos3D):
	tile_map[tile_pos2D].append(tile_pos3D)

func get_neighbors(tile_pos2D):
	return tile_map[tile_pos2D]

func set_level(new_level):
	if new_level != null:
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

func map_to_world2D(tile_pos2D):
	var world_pos2D = map_to_world(tile_pos2D - get_level_offset())
	return world_pos2D

func get_level_offset():
	return Vector2(level, level)

func get_overlay():
	return $Overlay

func add_draw_tile_pos3D(tile_pos3D, depth):
	$Overlay.add_draw_tile_pos3D(tile_pos3D, depth)

func clear_draw_tile_pos3D():
	$Overlay.clear_draw_tile_pos3D()

func has_draw_tile_pos3D(tile_pos3D):
	return $Overlay.tile_pos3D_to_draw.has(tile_pos3D)

func get_draw_tile_depth(tile_pos3D):
	return $Overlay.get_depth(tile_pos3D)