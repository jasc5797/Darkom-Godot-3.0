extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

var target_pos 
var angle = 0

func _ready():
	set_process(true)

func _process(delta):
	if target_pos != null:
		angle += delta
		set_position(Vector2(target_pos.x, target_pos.y + sin(angle) * 16))
	else:
		angle = 0

func set_character(character):
	if character.get_faction() == 0:
		set("self_modulate", Color(0, 1, 0))
	else:
		set("self_modulate", Color(1, 0, 0))
	set_tile_pos3D(character.get_tile_pos3D())
	set_position(get_position() +  Vector2(0, -80))
	target_pos = get_position()

