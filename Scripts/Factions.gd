extends Node

var PLAYER = 0
var ENEMY = 1

#Easy way to store strings for each faction name
var NAMES = ["Player", "Enemy"]

func get_faction_name(faction):
	return NAMES[faction]