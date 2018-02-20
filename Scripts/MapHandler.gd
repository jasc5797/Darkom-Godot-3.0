extends Node

var a_star = Resources.A_Star.new()

var Outline = load(Resources.OUTLINE_PATH)
var outline = Outline.instance()

var tile_map3D
var selected_tile_pos3D

#Key: Object Value: Pos   or visa versa    should be accessible by or passed to AStar 
var objects_on_map3D = {}

var tile_based_nodes = []

func _ready():
	add_child(outline)
	#set_process_unhandled_input(true)
	pass

func set_tile_map3D(new_tile_map3D):
	tile_map3D = new_tile_map3D
	tile_based_nodes = tile_map3D.get_children_tile_based_nodes()
	#could call clean here
	#for child in tile_map3D.get_children_tile_based_nodes():
	#	print(child.get_is_collidable())

func get_tile_map3D():
	return tile_map3D

func select_tile_pos2D(world_pos2D):
	var tile_pos3D_list
	if world_pos2D != null:
		tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		selected_tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
		if get_character_at_pos(selected_tile_pos3D) != null:
			outline.set_tile_pos3D(selected_tile_pos3D)
			outline.show()
		print("Selected Tile Pos: %s" %selected_tile_pos3D)
	else:
		selected_tile_pos3D = null
		outline.hide()

func move_to_tile_pos2D(world_pos2D):
	var tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		var tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
		#print(selected_tile_pos3D)
		#print(tile_pos3D)
		var character = get_character_at_pos(selected_tile_pos3D)
		if character != null:
			var tile_path3D = get_tile_pos3D_path(selected_tile_pos3D, tile_pos3D)
			var world_path3D = tile_path3D_to_world_path3D(tile_path3D)
			var world_path2D = []
			for world_pos3D in world_path3D:
				world_path2D.append(Vector2(world_pos3D.x, world_pos3D.y))
			character.set_path(world_path2D, tile_path3D)
			select_tile_pos2D(null)

func get_tile_pos3D_path(start_pos3D, end_pos3D):
	var tile_path3D = a_star.get_path(tile_map3D, start_pos3D, end_pos3D)
	return tile_path3D

func tile_path3D_to_world_path3D(tile_path3D):
	var world_path3D = []
	for tile_pos3D in tile_path3D:
		world_path3D.append(tile_map3D.map_to_world3D(tile_pos3D))
	return world_path3D

func get_tile_based_nodes():
	return tile_based_nodes

func get_character_at_pos(tile_pos3D):
	for node in tile_based_nodes:
		if node.get_tile_pos3D() == tile_pos3D:
			return node

#func _unhandled_input(event):
#	if event.is_action_released("left_click"):
#		print(a_star.get_path(tile_map3D, Vector3(0, 0, 0), Vector3(3, 2, 0)))