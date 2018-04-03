extends Sprite

export var speed_constant = 250

var selected_target

func _ready():
	hide()


func get_property(property):
	var name = get_name()
	return Abilities.get_ability_property(name, property)

func apply(attacker, target):
	pass

func is_in_range(attacker, target):
	var attacker_pos = attacker.get_tile_pos3D()
	var target_pos = target.get_tile_pos3D()
	var distance = get_property(Abilities.RANGE)
	return MapHandler.get_tile_pos3D_path(attacker_pos, target_pos, true).size() - 1 <= int(distance)

func has_resources(attacker):
	pass

func get_name():
	return "ABILITY"

func is_correct_target(attacker, target):
	if get_property(Abilities.TARGET) == Abilities.ENEMY:
		return attacker.faction != target.faction

func move_between_characters(attacker, target):
	var attacker_pos = attacker.get_global_position()
	var target_pos = target.get_global_position()
	look_at(target_pos)
	rotate(- PI / 2)
	var time = attacker_pos.distance_to(target_pos) / speed_constant
	$Tween.interpolate_property(self, "global_position", attacker_pos, target_pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	end()

func end():
	hide()
	queue_free()