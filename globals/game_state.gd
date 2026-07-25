extends Node

var player
#var last_location
var lvl_to_loc : Array[Vector2] = []
signal player_jumped
signal player_died

var master_volume: float = 0.5
var music_volume: float = 0.7
var sfx_volume: float = 0.4
var ambience_volume:float = 0.4

var current_level = 15
var current_lvl_path
var max_level_beaten = 0

func _ready() -> void:
	for i in range(30):
		lvl_to_loc.append(Vector2(-1000,-1000))

func update_max_level_beaten():
	max_level_beaten = max(current_level, max_level_beaten)
