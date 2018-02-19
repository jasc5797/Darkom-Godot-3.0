tool
extends Node2D


export(Vector3) var tile_pos3D = Vector3(0, 0, 0) setget set_tile_pos3D, get_tile_pos3D
export(Vector2) var tile_size = Vector2(64, 32) setget set_tile_size, get_tile_size

var collidable = true

func _ready():
	pass

#func _init(new_tile_pos3D, new_tile_size):
#	set_tile_pos3D(new_tile_pos3D)
#	set_tile_size(new_tile_size)

func set_tile_pos3D(new_tile_pos3D):
	#not sure why is editor hint is needed
	if new_tile_pos3D != null:# and Engine.is_editor_hint():
		tile_pos3D = new_tile_pos3D
		var x = tile_pos3D.x * tile_size.x / 2 - tile_pos3D.y * tile_size.x / 2
		var y = tile_pos3D.x * tile_size.y / 2 + tile_pos3D.y * tile_size.y / 2 - tile_pos3D.z * tile_size.y
		set_position(Vector2(x, y))
		#Trying to get a z level between each tilemap by multiplying the level by two 
		z_index = (tile_pos3D.z * 2) + 1

func get_tile_pos3D():
	return tile_pos3D

func set_tile_size(new_tile_size):
	if new_tile_size != null:
		tile_size = new_tile_size
		var x = tile_pos3D.x * tile_size.x / 2 - tile_pos3D.y * tile_size.x / 2
		var y = tile_pos3D.x * tile_size.y / 2 + tile_pos3D.y * tile_size.y / 2 - tile_pos3D.z * tile_size.y
		set_position(Vector2(x, y))

func get_tile_size():
	return tile_size

#rename to get_base_type() so children nodes can take advantage or their own get_type() while still being "TileBasedNodes"
func get_base_type():
	return "TileBasedNode"

func get_is_collidable():
	return collidable