tool
extends TileMap

export(int) var level = 0 setget set_level, get_level

#Valid/Walkable tiles
var tile_map = []

func _ready():
	initialize_tile_map()

func initialize_tile_map():
	for tile_pos in get_used_cells():
		#var id = get_cellv(tile_pos)
		#Select specific ids to add to valid tile_map
		tile_map.append(tile_pos)

func set_level(new_level):
	if level != null:
		level = new_level
		set_position(-Vector2(0, level * cell_size.y))
		#Trying to get a z level between each tilemap by multiplying the level by two 
		set_z_index(level * 2)

func get_level():
	return level

func has_tile_pos2D(tile_pos2D):
	var offset = Vector2(level, level)
	return tile_map.has(tile_pos2D)

func get_tile_map():
	return tile_map

func get_type():
	return "TileMap2D"

#Standard TileMap.world_to_map does not take into account the offset that is caused
#by setting the level
func world_to_map2D(world_pos2D):
	var tile_pos = world_to_map(world_pos2D) + get_level_offset()
	return tile_pos

func get_level_offset():
	return Vector2(level, level)