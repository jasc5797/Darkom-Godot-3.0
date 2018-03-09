tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

signal end_turn(character)

onready var tween = get_node("Tween")

export var faction = 0 setget set_faction, get_faction

var path
var tile_path

var MAX_STAMINA = 5
var stamina = MAX_STAMINA

var MAX_HEALTH = 5
var health = MAX_HEALTH

var is_turn = false

#Not used currently. Unsure if faction should be set dynamically
#var faction = Factions.PLAYER

func _ready():
	$StaminaBar.max_value = MAX_STAMINA
	$HealthBar.max_value = MAX_HEALTH
	$HealthBar.value = health

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
			$StaminaBar.value = stamina


func start_turn():
	is_turn = true
	stamina = MAX_STAMINA
	$StaminaBar.value = stamina
	print($StaminaBar.value)

func move_to_pos(pos):
	tween.interpolate_property(self, "position", get_position(), pos, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	


func _on_Tween_completed( object, key ):
	var tile_pos3D = tile_path.front()
	set_tile_pos3D(tile_pos3D)
	tile_path.pop_front()
	move_on_path()

func set_faction(value):
	if value != null:
		faction = value

func get_faction():
	return faction

func get_type():
	return "Character"