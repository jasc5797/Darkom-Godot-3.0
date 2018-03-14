tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

export var faction = 0 setget set_faction, get_faction

signal end_turn(character)
signal target_character(character)

onready var tween = get_node("Tween")



var path
var tile_path

var MAX_STAMINA = 5
var stamina = MAX_STAMINA

var MAX_HEALTH = 5
var health = MAX_HEALTH

var is_turn = false

var selected_ability

#Not used currently. Unsure if faction should be set dynamically
#var faction = Factions.PLAYER

func _ready():
	$StaminaBar.max_value = MAX_STAMINA
	$HealthBar.max_value = MAX_HEALTH
	$HealthBar.value = health

func set_path(new_world_path, new_tile_path):
	path = new_world_path
	tile_path = new_tile_path
	path.pop_front()
	tile_path.pop_front()
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
			adjust_stamina(-1)

func adjust_stamina(value):
	stamina += value
	$StaminaBar.value = stamina

func adjust_health(value):
	health += value
	$HealthBar.value = health

func start_turn():
	is_turn = true
	stamina = MAX_STAMINA
	$StaminaBar.value = stamina
	#print($StaminaBar.value)

func move_to_pos(pos):
	tween.interpolate_property(self, "position", get_position(), pos, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	

func _on_Tween_completed( object, key ):
	var tile_pos3D = tile_path.front()
	set_tile_pos3D(tile_pos3D)
	tile_path.pop_front()
	move_on_path()

func ability_selected(ability):
	selected_ability = ability
	emit_signal("target_character", self)

func attack(target_character):
	if selected_ability == 1:
		var damage = Abilities.get_damage("Punch")
		var stamina = Abilities.get_stamina("Punch")
		adjust_stamina(stamina)
		target_character.adjust_health(damage)
	selected_ability = null


func set_faction(value):
	if value != null:
		faction = value
		if faction == 1:
			set("self_modulate", Color(1, 0, 0))

func get_faction():
	return faction

func get_type():
	return "Character"