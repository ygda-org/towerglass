extends Node

var current_level: int = 0

var leaderboards = []
var names = []
var new_best_time: int = -1
var level_time: float = 0.0

var save_path = "user://towerglass_save.save"

func _ready():
	for i in range(14): # number of levels
		leaderboards.append([])
		names.append([])
	if not FileAccess.file_exists(save_path):
		return # No file found
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var parse = JSON.parse_string(save_file.get_line())
	leaderboards = parse["times"]
	names = parse["names"]


func _process(delta):
	level_time += delta

func level_started(num):
	current_level = num
	level_time = 0.0

func level_finished():
	var spot_found: bool = false
	for i in range(leaderboards[current_level].size()):
		if level_time < leaderboards[current_level][i]:
			leaderboards[current_level].insert(i, level_time)
			spot_found = true
			if i < 3:
				new_best_time = i
			break
	if not spot_found:
		leaderboards[current_level].append(level_time)
		spot_found = true
		if leaderboards[current_level].size() < 4:
			new_best_time = leaderboards[current_level].size()-1
	save()

func save():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	var save_dict = {
		"names": names,
		"times": leaderboards
	}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)

func get_top_three_string() -> String:
	var ret = "Best times:\n"
	names[current_level].insert(new_best_time, "You")
	if names[current_level].size() > 3:
		names[current_level].remove_at(-1)
	for i in range(names[current_level].size()):
		ret += "{0}: {1}\n".format([names[current_level][i], str(snappedf(leaderboards[current_level][i], 0.01))])
	return ret
