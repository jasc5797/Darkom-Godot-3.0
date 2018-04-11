extends Node2D

var tile_pos3D_to_draw = {}

var overlay_tile_pos3D_list = []

var tile_pos2D_to_label = []

var path = []

var DEBUG = false

func _ready():
	pass

func set_overlay_tile_pos3D_list(tile_pos3D_list):
	overlay_tile_pos3D_list = tile_pos3D_list

func clear():
	overlay_tile_pos3D_list.clear()
	update()

func _draw():
	for tile_pos3D in tile_pos3D_to_draw:
		var color = Color(15/255.0, 149/255.0, 239/255.0, 0.3)
		var tile_pos2D = Vector2(tile_pos3D.x, tile_pos3D.y)
		var world_pos2D = get_parent().map_to_world(tile_pos2D)
		#draw_circle(world_pos2D + Vector2(0, 15), 10, color)
		var points = []
		var tile_id = get_parent().get_cellv(tile_pos2D)
		var tile_name = get_parent().tile_set.tile_get_name(tile_id)
		if tile_name.find("U") > - 1:
			if "Left" in tile_name:
				points.append(world_pos2D + Vector2(0, -32))
				points.append(world_pos2D + Vector2(32, -16))
				points.append(world_pos2D + Vector2(0, 32))
				points.append(world_pos2D + Vector2(-32, 16))
			if "Right" in tile_name:
				points.append(world_pos2D + Vector2(0, 32))
				points.append(world_pos2D + Vector2(-32, -16))
				points.append(world_pos2D + Vector2(0, -32))
				points.append(world_pos2D + Vector2(32, 16))
		else:
			points.append(world_pos2D)
			points.append(world_pos2D + Vector2(32, 16))
			points.append(world_pos2D + Vector2(0, 32))
			points.append(world_pos2D + Vector2(-32, 16))
		draw_polygon(points, [color])
	if DEBUG:
		for tile_pos2D in tile_pos2D_to_label:
			draw_string($Label.get_font("font"), get_parent().map_to_world(tile_pos2D) + Vector2(-16, 24), String(tile_pos2D), $Label.get_color("font_color")) 
	if path != null: 
		for index in range(0, path.size()):
			var current_tile3D = path[index]
			var current_tile2D = Vector2(current_tile3D.x, current_tile2D.y)
			var world_pos2D = get_parent().map_to_world(current_tile2D)
			if current_tile3D.z == get_parent().get_level():
				if index > 0:
					var previous_tile3D = path[index - 1]
					var previous_tile2D = Vector2(previous_tile3D.x, previous_tile3D.y)
					var previous_world_pos2D = get_parent().map_to_world(previous_tile2D)
					draw_line(world_pos2D, previous_world_pos2D, Color(1, 1, 1), 5, true)
				elif index < path.size():
					var next_tile3D = path[index + 1]
					var next_tile2D = Vector2(next_tile3D.x, next_tile3D.y)
					var next_world_pos2D = get_parent().map_to_world(next_tile2D)
					draw_line(world_pos2D, next_world_pos2D, Color(1, 1, 1), 5, true)


func clear_draw_tile_pos3D():
	tile_pos3D_to_draw.clear()
	update()

func add_draw_tile_pos3D(tile_pos3D, depth):
	if !tile_pos3D_to_draw.has(tile_pos3D):
		tile_pos3D_to_draw[tile_pos3D] = depth
	update()

func get_depth(tile_pos3D):
	if tile_pos3D_to_draw.has(tile_pos3D):
		return tile_pos3D_to_draw[tile_pos3D]

func add_tile_pos_to_label(tile_pos2D):
	tile_pos2D_to_label.append(tile_pos2D)
	update()

func draw_path(new_path):
	if path != new_path:
		path = new_path
		update()


func clear_path():
	path.clear()