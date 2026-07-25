extends Node

var player
var last_location
signal player_jumped
signal player_died

var master_volume: float = 0.5
var music_volume: float = 0.7
var sfx_volume: float = 0.4
var ambience_volume:float = 0.4

var current_level
var max_level_beaten = 0

func update_max_level_beaten():
	max_level_beaten = max(current_level, max_level_beaten)
