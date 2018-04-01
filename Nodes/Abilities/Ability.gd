extends Sprite

func _ready():
	pass

func move_between_characters(attacker, target):
	rotate(get_angle_to(target.get_position()))
	$Tween.interpolate_property(self, "position", get_position() + Vector2(0, 0), target.get_position(), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()



func _on_Tween_tween_completed(object, key):
	hide()
	queue_free()
