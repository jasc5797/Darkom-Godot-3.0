extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

#export (String, "Player", "Enemy") var faction
export (PackedScene) var entity setget set_entity, get_entity

func _ready():
	if Engine.is_editor_hint():
		#add_child(entity.instance())
		show()
	else:
		hide()
	collidable = false

#func get_faction():
#	return faction

func set_entity(value):
	entity = value

func get_entity():
	return entity