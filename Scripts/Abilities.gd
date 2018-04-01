tool

extends Node

# Targets: Self, teammates, multiple of same or different time

var PUNCH = { "NAME" : "Punch", "DAMAGE" : "-1", "STAMINA" : "-1","TARGET" : "ENEMY" }

var TARGET = "TARGET"
var ENEMY = "ENEMY"

var DAMAGE = "DAMAGE"
var RANGE = "RANGE"
var STAMINA = "STAMINA"

var ABILITIES = [PUNCH]

func get_ability(name):
	for ability in ABILITIES:
		if ability["NAME"] == name:
			return ability

func get_damage(name):
	var ability = get_ability(name)
	if ability != null:
		return int(ability["DAMAGE"])

func get_target(name):
	var ability = get_ability(name)
	if ability != null:
		return ability["TARGET"]

func get_stamina(name):
	var ability = get_ability(name)
	if ability != null:
		return int(ability["STAMINA"])