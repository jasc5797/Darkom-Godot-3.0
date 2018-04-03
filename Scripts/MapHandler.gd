extends Node2D

var a_star = Resources.A_Star.new()

var Outline = load(Resources.OUTLINE_PATH)
var outline = Outline.instance()

var tile_map3D
var tile_camera

var selected_tile_pos3D
var hovered_over_tile_pos3D

signal move_camera(tile_pos3D)

#Key: Object Value: Pos   or visa versa    should be accessible by or passed to AStar 
var objects_on_map3D = {}

var tile_based_nodes = []

var attacking_character

var ysort

func set_ysort(new_ysort):
	ysort = new_ysort

func _ready():
	add_child(a_star)
	add_child(outline)

func set_target_character():
	var target_character = true

func set_tile_map3D(new_tile_map3D):
	tile_map3D = new_tile_map3D
	tile_based_nodes = tile_map3D.get_children_tile_based_nodes()
	for node in tile_based_nodes:
		if node.get_type() == "Character":
			TurnManager.add_character(node, node.get_faction())
			#tile_map3D.remove_child(node)
			#ysort.add_child(node)
			node.connect("target_character", self, "set_attacking_character")
			node.connect("follow_me", self, "set_camera_follow_character")
			node.connect("deselect_me", self, "deselect_character")
	TurnManager.start_turn()
	#could call clean here

func set_tile_camera(new_tile_camera):
	tile_camera = new_tile_camera

func set_attacking_character(new_attacking_character):
	attacking_character = new_attacking_character

func deselect_character(character):
	if selected_tile_pos3D == character.get_tile_pos3D():
		select_tile_pos2D(null)

func set_camera_follow_character(character):
	if tile_camera != null:
		tile_camera.set_follow_character(character)

func get_tile_map3D():
	return tile_map3D

func select_tile_pos2D(world_pos2D):
	var tile_pos3D_list
	if world_pos2D != null:
		tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		var tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
		var character = get_character_at_pos(tile_pos3D) 
		if character != null:
			if attacking_character != null:
				attacking_character.attack(character)
				attacking_character = null
			elif TurnManager.is_characters_turn(character):
				selected_tile_pos3D = tile_pos3D
				outline.set_tile_pos3D(selected_tile_pos3D)
				outline.show()
				draw_radius(character.get_tile_pos3D(), character.stamina, false)
		#print("Selected Tile Pos: %s" %selected_tile_pos3D)
	else:
		selected_tile_pos3D = null
		outline.hide()
		tile_map3D.clear_draw_tile_pos()

func set_hovered_over_tile2D(world_pos2D):
	var tile_pos3D_list
	if world_pos2D != null:
		tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		hovered_over_tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
	else:
		hovered_over_tile_pos3D = null


func move_to_tile_pos2D(world_pos2D):
	var tile_pos3D_list = tile_map3D.world2D_to_map3D_list(world_pos2D)
	if tile_pos3D_list != null and !tile_pos3D_list.empty():
		var tile_pos3D = tile_map3D.world2D_to_map3D(tile_pos3D_list)
		#print(selected_tile_pos3D)
		#print(tile_pos3D)
		var character = get_character_at_pos(selected_tile_pos3D)
		if character != null:
			var tile_path3D = get_tile_pos3D_path(selected_tile_pos3D, tile_pos3D, false)
			var world_path3D = tile_path3D_to_world_path3D(tile_path3D)
			var world_path2D = []
			for world_pos3D in world_path3D:
				world_path2D.append(Vector2(world_pos3D.x, world_pos3D.y))
			character.set_path(world_path2D, tile_path3D)
			select_tile_pos2D(null)
			tile_map3D.clear_draw_tile_pos()

func get_tile_pos3D_path(start_pos3D, end_pos3D, ignore_nodes):
	var tile_path3D = a_star.get_path(tile_map3D, start_pos3D, end_pos3D, tile_based_nodes, ignore_nodes)
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
		if node.get_tile_pos3D() == tile_pos3D && node.collidable:
			return node


func ability_selected(ability):
	var character = get_character_at_pos(selected_tile_pos3D)
	if character != null:
		character.ability_selected(ability)

func draw_radius(start_pos3D, radius, ignore_nodes):
	tile_map3D.clear_draw_tile_pos()
	draw_tile_pos(start_pos3D, start_pos3D, radius, 0, ignore_nodes)

func draw_tile_pos(start_pos3D, tile_pos3D, radius, current_depth, ignore_nodes):
	if current_depth <= radius :
		tile_map3D.draw_tile_pos(tile_pos3D, current_depth)
		for neighbor_pos3D in tile_map3D.get_neighbors(tile_pos3D):
			if !tile_map3D.has_draw_tile_pos3D(neighbor_pos3D) or tile_map3D.get_draw_tile_depth(neighbor_pos3D) > current_depth:
				if ignore_nodes or get_character_at_pos(neighbor_pos3D) == null:
					draw_tile_pos(start_pos3D, neighbor_pos3D, radius, current_depth + 1, ignore_nodes)

