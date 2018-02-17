tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

onready var tween = get_node("Tween")

var path

func _ready():
	pass

func set_path(new_path):
	path = new_path
	move_on_path()

func move_on_path():
	if not path.empty():
		var pos = path.front()
		#set_sprite(get_pos(), pos)
		move_to_pos(pos)
		path.pop_front()


func move_to_pos(pos):
	tween.interpolate_property(self, "transform/pos", get_pos(), pos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_Tween_completed( object, key ):
	move_on_path()

func get_type():
	return "Character"