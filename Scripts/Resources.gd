extends Node

# Script paths and loaded resources
const A_STAR_PATH = "res://Scripts/AStar.gd"
var A_Star = load(A_STAR_PATH)

const PRIORITY_QUEUE_PATH = "res://Scripts/PriorityQueue.gd"
var PriorityQueue = load(PRIORITY_QUEUE_PATH)

#Tried to use this to see if other nodes could extend it
const TILE_BASED_NODE_PATH = "res://Nodes/TileBasedNode/TileBasedNode.gd"
var TileBasedNode = load(TILE_BASED_NODE_PATH)

# Node Paths
const CHARACTER_PATH = "res://Nodes/Character/Character.tscn"

#Ability Paths
const PUNCH_PATH = "res://Nodes/Abilities/Punch/Punch.tscn"
var Punch = load(PUNCH_PATH)

const FIREBALL_PATH = "res://Nodes/Abilities/FireBall/FireBall.tscn"
var FireBall = load(FIREBALL_PATH)

const OUTLINE_PATH = "res://Nodes/Outline/Outline.tscn"

# JSON File Paths
const ABILITIES_PATH = "res://Nodes/Abilities/Abilities.json"