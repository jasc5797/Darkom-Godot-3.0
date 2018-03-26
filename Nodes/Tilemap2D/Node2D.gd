extends Node2D

var tile_pos3D_to_draw = {}

func _ready():
	pass

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
