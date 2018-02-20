tool
extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

onready var tween = get_node("Tween")

var path
var tile_path

func _ready():
	pass

func set_path(new_world_path, new_tile_path):
	path = new_world_path
	tile_path = new_tile_path
	move_on_path()

func move_on_path():
	if path != null and not path.empty():
		var pos = path.front()
		#set_sprite(get_pos(), pos)
		move_to_pos(pos)
		path.pop_front()


func move_to_pos(pos):
	tween.interpolate_property(self, "position", get_position(), pos, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	


func _on_Tween_completed( object, key ):
	var tile_pos3D = tile_path.front()
	set_tile_pos3D(tile_pos3D)
	# needed so the character doesnt draw under the level they are moving onto
	# tile_path.size() > 1:
	#	if tile_path[0].z < tile_path[1].z:
	#		z_index += 1
	tile_path.pop_front()
	move_on_path()

func get_type():
	return "Character"