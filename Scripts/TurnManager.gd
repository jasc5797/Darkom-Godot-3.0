extends Node

var faction_to_characters = {}
var faction_order = []

var turn_queue = []
var current_characters = []


func _ready():
	set_process(true)

func _process(delta):
	if current_characters.empty():
		end_turn()
		start_turn()

func initialize():
	turn_queue = faction_order

func add_character(character, faction):
	if character.get_type() == "Character":
		if !faction_to_characters.has(faction):
			faction_to_characters[faction] = []
			faction_order.append(faction)
			turn_queue = faction_order
		faction_to_characters[faction].append(character)
		character.connect("end_turn", self, "character_turn_ended")
	else:
		print("Not an instance of a character")

func set_faction_index(faction, index):
	var current_index = faction_order.find(faction)
	faction_order.remove(current_index)
	faction_order.insert(index, faction)
	turn_queue = faction_order

func character_turn_ended(character):
	end_character_turn(character)

func end_character_turn(character):
	var index = current_characters.find(character)
	current_characters.remove(index)

func is_characters_turn(character):
	return current_characters.has(character)

func start_turn():
	current_characters = faction_to_characters[get_current_faction()]. duplicate()
	for character in current_characters:
		character.start_turn()

func end_turn():
	var current_faction = turn_queue.front()
	turn_queue.pop_front()
	turn_queue.append(current_faction)

func get_current_faction():
	return turn_queue.front()