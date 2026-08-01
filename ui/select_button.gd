extends TextureButton

const LEVEL_ORDER = [
	"res://levels/tutorial.tscn",
	"res://levels/moving.tscn",
	"res://levels/crumbling.tscn",
	"res://levels/on_off.tscn",
	"res://levels/turrets_level.tscn",
	"res://levels/touch_and_go.tscn",
	"res://levels/aww_rats.tscn",
	"res://levels/trampoline.tscn",
	"res://levels/best_buds.tscn",
	"res://levels/challenge_1.tscn",
	"res://levels/motion_turrets.tscn",
	"res://levels/limit.tscn",
	"res://levels/elevator.tscn",
	"res://levels/finale.tscn",
	"res://main/end_screen.tscn"
	]

@export var number : int = 0
var target : String

@export var level_song: Music.Labels = Music.Labels.EARLY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target = LEVEL_ORDER[number-1]
	$Number.text = str(number)
	if number == 15:
		$Number.text = ""
		custom_maximum_size.x += 16
	if GameState.max_level_beaten + 1 < number:
		queue_free()

func _on_pressed() -> void:
	GameState.level_select_entry = true
	GameState.current_level = number
	GameState.current_lvl_path = target
	SFX.play(SFX.Labels.BUTTONCLICK)
	Music.start(level_song)
	SceneSwitcher.go_to_scene(target)


func _on_mouse_entered():
		SFX.play(SFX.Labels.BUTTONHOVER)
