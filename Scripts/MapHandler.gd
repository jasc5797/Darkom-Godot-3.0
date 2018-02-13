extends Node

var a_star = Resources.A_Star.new()

var tile_map3D
var selected_tile_pos3D

#Key: Object Value: Pos   or visa versa    should be accessible by or passed to AStar 
var objects_on_map3D = {}

func _ready():
	#set_process_unhandled_input(true)
	pass

func set_tile_map3D(new_tile_map3D):
	tile_map3D = new_tile_map3D

func get_tile_map3D():
	return tile_map3D

func select_tile_pos2D(world_pos2D):
	var tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		selected_tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
		print("Selected Tile Pos: %s" %selected_tile_pos3D)
	else:
		selected_tile_pos3D = null

func move_to_tile_pos2D(world_pos2D):
	var tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		var tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
		#print(selected_tile_pos3D)
		#print(tile_pos3D)
		return get_tile_pos3D_path(selected_tile_pos3D, tile_pos3D)

func get_tile_pos3D_path(start_pos3D, end_pos3D):
	var tile_path3D = a_star.get_path(tile_map3D, start_pos3D, end_pos3D)
	print(tile_path3D)
	return tile_path3D



#func _unhandled_input(event):
#	if event.is_action_released("left_click"):
#		print(a_star.get_path(tile_map3D, Vector3(0, 0, 0), Vector3(3, 2, 0)))