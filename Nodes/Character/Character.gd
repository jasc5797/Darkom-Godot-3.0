tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

signal end_turn(character)

onready var tween = get_node("Tween")

var path
var tile_path

var MAX_STAMINA = 5
var stamina = MAX_STAMINA

var is_turn = false

#Not used currently. Unsure if faction should be set dynamically
#var faction = Factions.PLAYER

func _ready():
	$ProgressBar.max_value = MAX_STAMINA

func set_path(new_world_path, new_tile_path):
	path = new_world_path
	tile_path = new_tile_path
	move_on_path()

func move_on_path():
	if is_turn:
		if stamina == 0:
			path.clear()
			is_turn = false
			emit_signal("end_turn", self)
		if path != null and not path.empty():
			var pos = path.front()
			#set_sprite(get_pos(), pos)
			z_index += 2
			move_to_pos(pos)
			path.pop_front()
			stamina -= 1
			$ProgressBar.value = stamina


func start_turn():
	is_turn = true
	stamina = MAX_STAMINA
	$ProgressBar.value = stamina

func move_to_pos(pos):
	tween.interpolate_property(self, "position", get_position(), pos, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	


func _on_Tween_completed( object, key ):
	var tile_pos3D = tile_path.front()
	set_tile_pos3D(tile_pos3D)
	tile_path.pop_front()
	move_on_path()

#func get_faction():
#	return faction

func get_type():
	return "Character"