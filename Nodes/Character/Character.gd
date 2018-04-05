tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

export var faction = 0 setget set_faction, get_faction

signal end_turn(character)
signal target_character(character)
signal deselect_me(character)

#camera singles
signal follow_me(character)

onready var tween = get_node("Tween")



var path
var tile_path

var MAX_STAMINA = 5
var stamina = MAX_STAMINA

var MAX_HEALTH = 5
var health = MAX_HEALTH

var is_turn = false

var selected_ability

var abilities = {}

#Not used currently. Unsure if faction should be set dynamically
#var faction = Factions.PLAYER

func _ready():
	read_abilities()
	$StaminaBar.max_value = MAX_STAMINA
	$HealthBar.max_value = MAX_HEALTH
	$HealthBar.value = health

func read_abilities():
	var file = File.new()
	file.open(Resources.ABILITIES_PATH, File.READ)
	var json = file.get_as_text()
	abilities = JSON.parse(json).result
	file.close()

func set_path(new_world_path, new_tile_path):
	path = new_world_path
	tile_path = new_tile_path
	path.pop_front()
	tile_path.pop_front()
	move_on_path()

func move_on_path():
	if is_turn:
		emit_signal("follow_me", self)
		if stamina == 0:
			path.clear()
			is_turn = false
			emit_signal("end_turn", self)
			emit_signal("deselect_me", self)
		if path != null and not path.empty():
			var pos = path.front()
			#set_sprite(get_pos(), pos)
			z_index += 2
			move_to_pos(pos)
			path.pop_front()
			adjust_stamina(-1)
		elif path != null and path.empty():
			emit_signal("follow_me", null)


func adjust_stamina(value):
	stamina += int(value)
	$StaminaBar.value = stamina

func adjust_health(value):
	health += int(value)
	$HealthBar.value = health

func start_turn():
	is_turn = true
	stamina = MAX_STAMINA
	$StaminaBar.value = stamina

func end_turn():
	selected_ability = null
	if stamina == 0:
		if path != null:
			path.clear()
		is_turn = false
		emit_signal("end_turn", self)
	emit_signal("deselect_me", self)

func move_to_pos(pos):
	tween.interpolate_property(self, "position", get_position(), pos, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Tween_completed( object, key ):
	var tile_pos3D = tile_path.front()
	set_tile_pos3D(tile_pos3D)
	tile_path.pop_front()
	move_on_path()

func ability_selected(ability):
	selected_ability = Abilities.instance_ability(ability)
	if selected_ability != null and selected_ability.has_resources(self):
		var distance = selected_ability.get_property(Abilities.RANGE)
		MapHandler.draw_radius(get_tile_pos3D(), distance, true)
		emit_signal("target_character", self)
	else:
		emit_signal("deselect_me", self)

func attack(target):
	if selected_ability != null and selected_ability.is_correct_target(self, target):
		add_child(selected_ability)
		selected_ability.apply(self, target)
	end_turn()

func set_faction(value):
	if value != null:
		faction = value
		if faction == 1:
			set("self_modulate", Color(1, 0, 0))

func get_faction():
	return faction

func get_type():
	return "Character"