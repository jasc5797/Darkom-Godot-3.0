extends Node2D

func _ready():
	#OS.set_window_maximized(true)
	set_process(true)
	set_process_unhandled_input(true)
	var tile_map3D = get_child(0)
	MapHandler.add_tile_map3D(tile_map3D)
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event.is_action_released("left_click"):
		MapHandler.get_tile_pos3D_at_world_pos(get_global_mouse_position())