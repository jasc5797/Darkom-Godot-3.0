extends Node2D

var Current_Map = load(Resources.LEVEL_1_PATH)

func _ready():
	#OS.set_window_maximized(true)
	var tile_map3D = Current_Map.instance()
	add_child(tile_map3D)
	MapHandler.add_tile_map3D(tile_map3D)	
	set_process(true)
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.is_action_released("left_click"):
		MapHandler.select_tile_pos2D(get_global_mouse_position())