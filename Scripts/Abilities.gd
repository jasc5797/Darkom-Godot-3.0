tool extends Node

#Property names
var DAMAGE = "DAMAGE"
var RANGE = "RANGE"
var STAMINA = "STAMINA"
var TARGET = "TARGET"

#Property values
#TARGET values
var ENEMY = "ENEMY"

#Ability Names
var PUNCH = "PUNCH"
var FIRE_BALL = "FIRE_BALL"

var abilities = {}

func _ready():
	read_abilities_from_file()

func read_abilities_from_file():
	var file = File.new()
	file.open(Resources.ABILITIES_PATH, File.READ)
	var json = file.get_as_text()
	abilities = JSON.parse(json).result
	file.close()

func get_ability_property(ability_name, property):
	return abilities[ability_name][property]

func instance_ability(ability_name):
	if ability_name == PUNCH:
		#return
		pass
	elif ability_name == FIRE_BALL:
		return Resources.FireBall.instance()