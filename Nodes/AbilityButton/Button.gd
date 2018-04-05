tool
extends Button

export(PackedScene) var ability_scene setget set_ability_scene, get_ability_scene

func _ready():
	pass

func set_ability_scene(new_ability_scene):
	if new_ability_scene != null:
		ability_scene = new_ability_scene
		var ability = ability_scene.instance()
		text = ability.get_name()

func get_ability_scene():
	return ability_scene