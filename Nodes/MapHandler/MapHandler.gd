extends Node

var a_star = Resources.A_Star.new()

var tile_map3D

func _ready():
	#set_process_unhandled_input(true)
	pass

func add_tile_map3D(new_tile_map3D):
	tile_map3D = new_tile_map3D

func get_tile_pos3D_list_at_world_pos(world_pos2D):
	var tile_pos3D_list = []
	for level in tile_map3D.get_levels():
		var tile_map2D = tile_map3D.get_level(level)
		var tile_pos2D = tile_map2D.world_to_map2D(world_pos2D)
		print("Level: %d" % tile_map2D.get_level())
		print(tile_pos2D)
		if tile_map2D.has_tile_pos2D(tile_pos2D):
			tile_pos_list.append(Vector3(tile_pos2D.x, tile_pos2D.y, tile_map2D.get_level()))
	print(tile_pos3D_list)
	return tile_pos3D_list

#func _unhandled_input(event):
#	if event.is_action_released("left_click"):
#		print(a_star.get_path(tile_map3D, Vector3(0, 0, 0), Vector3(3, 2, 0)))