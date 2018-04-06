tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

func _ready():
	if Engine.is_editor_hint():
		show()
	else:
		hide()
	collidable = false

func get_type():
	return "PlayerSpawnPoint"