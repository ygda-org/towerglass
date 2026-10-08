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

var current_level = 0
var current_lvl_path
var max_level_beaten = 0

var player_death_count = 0

var level_select_entry : bool = false

var reset_level_select_music : bool = true

var arcade_mode: bool = false

func _ready() -> void:
	if not arcade_mode:
		if Input.is_joy_known(0) or Input.is_joy_known(1):
			arcade_mode = true
			var grad: GradientTexture1D = GradientTexture1D.new()
			grad.gradient = Gradient.new()
			grad.gradient.remove_point(0)
			grad.gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.0))
			grad.width = 1
			Input.set_custom_mouse_cursor(grad)
	for i in range(30):
		lvl_to_loc.append(Vector2(-1000,-1000))
	player_died.connect(death_counter_increment)

func update_max_level_beaten():
	max_level_beaten = max(current_level, max_level_beaten)

func death_counter_increment():
	player_death_count += 1
