extends Node2D

var Current_Map = load(Maps.SMALL_PATH)

var Character = load(Resources.CHARACTER_PATH)

func _ready():
	#OS.set_window_maximized(true)
	MapHandler.set_tile_camera($TileCamera)
	MapHandler.set_ysort($YSort)
	var tile_map3D = Current_Map.instance()
	add_child(tile_map3D)
	var character = Character.instance()
	#character.set_tile_pos3D(Vector3(5, -2, 1))
	#add_child(character)
	MapHandler.set_tile_map3D(tile_map3D)
	#print(MapHandler.get_tile_based_nodes())
	set_process(true)
	set_process_unhandled_input(true)
	$CanvasLayer/AbilityBar.connect("ability_selected", self, "ability_selected")

func ability_selected(ability):
	MapHandler.ability_selected(ability)

func _unhandled_input(event):
	if event.is_action_released("left_click"):
		MapHandler.select_tile_pos2D(get_global_mouse_position())
		var character = MapHandler.get_character_at_pos(MapHandler.selected_tile_pos3D)
		if character != null and TurnManager.is_characters_turn(character):
			$TileCamera.move_to_tile_pos3D(character.get_tile_pos3D())
	if event.is_action_released("right_click"):
		MapHandler.move_to_tile_pos2D(get_global_mouse_position())
	if event is InputEventMouseMotion:
		MapHandler.set_hovered_over_tile2D(get_global_mouse_position())


#May or may not be needed
func _exit_true():
	Current_Map.free()
	Character.free()