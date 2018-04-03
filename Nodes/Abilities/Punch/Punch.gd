extends "res://Nodes/Abilities/Ability.gd"

func _ready():
	pass

func apply(attacker, target):
	attacker.adjust_stamina(get_property(Abilities.STAMINA))
	target.adjust_health(get_property(Abilities.DAMAGE))
	end()

func has_resources(attacker):
	return attacker.stamina >= int(get_property(Abilities.STAMINA))

func get_name():
	return Abilities.PUNCH