extends "res://Nodes/Abilities/Ability.gd" 

func _ready():
	pass

func apply(attacker, target):
	attacker.adjust_stamina(get_property(Abilities.STAMINA))
	selected_target = target
	#.apply(attacker, target)
	move_between_characters(attacker, target)

func has_resources(attacker):
	return attacker.stamina >= int(get_property(Abilities.STAMINA))

func get_name():
	return Abilities.FIRE_BALL

func move_between_characters(attacker, target):
	show()
	.move_between_characters(attacker, target)

func _on_Tween_tween_completed(object, key):
	if selected_target != null:
		selected_target.adjust_health(get_property(Abilities.DAMAGE))
	._on_Tween_tween_completed(object, key)