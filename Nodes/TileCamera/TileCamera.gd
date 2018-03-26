extends "res://Nodes/TileBasedNode/TileBasedNode.gd"

var move_to_tile_pos3D
var character_to_follow

func _ready():
	set_process(true)

func _process(delta):
	if character_to_follow != null:
		set_position(character_to_follow.get_position())
	else:
		var movement_vector = Vector2(0, 0)
		if Input.is_action_pressed("ui_up"):
			movement_vector += Vector2(0, -1)
		if Input.is_action_pressed("ui_down"):
			movement_vector += Vector2(0, 1)
		if Input.is_action_pressed("ui_left"):
			movement_vector += Vector2(-1, 0)
		if Input.is_action_pressed("ui_right"):
			movement_vector += Vector2(1, 0)
		var new_pos = get_position() + movement_vector.normalized() * 500 * delta
		set_position(new_pos)

func set_follow_character(character):
	character_to_follow = character

func move_to_tile_pos3D(new_tile_pos3D):
	move_to_tile_pos3D = new_tile_pos3D
	var world_pos3D = MapHandler.get_tile_map3D().map_to_world3D(move_to_tile_pos3D)
	var world_pos2D = Vector2(world_pos3D.x, world_pos3D.y)
	$Tween.interpolate_property(self, "position", get_position(), world_pos2D, 1.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _on_Tween_completed(object, key):
	set_tile_pos3D(move_to_tile_pos3D)
