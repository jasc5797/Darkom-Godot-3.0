extends Node

var characters = {}

func _ready():
	read_characters_from_file()
	print_characters()
	save_characters_to_file(characters)

func read_characters_from_file():
	var file = File.new()
	file.open(Resources.CHARACTERS_PATH, File.READ)
	var json = file.get_as_text()
	characters = JSON.parse(json).result
	file.close()

func save_characters_to_file(dictionary):
	var file = File.new()
	file.open(Resources.CHARACTERS_PATH, File.WRITE)
	file.store_line(to_json(characters))
	file.close()

func write_character(file, character):
	var attributes = characters[character]
	file.store_line(to_json(character))
	for attribute in attributes:
		write_attribute(file, attribute)

func write_attribute(file, attribute):
	file.store_line(to_json(attribute))

func print_characters():
	for character in characters:
		print("Character: %s" % [character])
		for attribute in characters[character]:
			print("%s : %s" % [attribute, characters[character][attribute]])
		print("")