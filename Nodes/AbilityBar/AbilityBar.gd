extends HBoxContainer

signal ability_selected(ability)

func _ready():
	set_process_input(true)

func _input(event):
	#	if event.is_action("1"):
	if event.is_action_pressed("ability_1"):
		set_ability_selected(1)
	if event.is_action_pressed("ability_2"):
		set_ability_selected(2)

func set_ability_selected(ability):
	emit_signal("ability_selected", ability)

func button1_released():
	set_ability_selected(1)

func button2_released():
	set_ability_selected(2)