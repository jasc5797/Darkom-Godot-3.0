extends HBoxContainer

signal ability_selected(ability)

var character

func _ready():
	set_process_input(true)

func set_character(new_character):
	character = new_character

func _input(event):
	#	if event.is_action("1"):
	if event.is_action_pressed("ability_1"):
		set_ability_selected(1)
	if event.is_action_pressed("ability_2"):
		set_ability_selected(2)

func set_ability_selected(ability):
	emit_signal("ability_selected", ability)

func button1_released():
	set_ability_selected(Abilities.PUNCH)

func button2_released():
	set_ability_selected(Abilities.FIRE_BALL)

func _on_Button3_button_up():
	set_ability_selected(Abilities.ARROW)
