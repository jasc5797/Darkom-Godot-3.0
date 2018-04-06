extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

export (String, "Player", "Enemy") var faction

func _ready():
	if Engine.is_editor_hint():
		show()
	else:
		hide()
	collidable = false

func get_faction():
	return faction
