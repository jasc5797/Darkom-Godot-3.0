extends Sprite

func _ready():
	pass

func move_between_characters(attacker, target):
	look_at(target.get_global_position())
	rotate(- PI / 2)
	$Tween.interpolate_property(self, "global_position", get_global_position(), target.get_global_position(), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	hide()
	queue_free()
