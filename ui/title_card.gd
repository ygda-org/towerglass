extends Control

const LEVEL_NAME = [
	"Beginnings",
	"Movement",
	"Stability",
	"Flip",
	"Fire!",
	"Touch And Go",
	"Aww Rats",
	"Momentum",
	"Best Buds",
	"The Tower",
	"Whiplash",
	"Limits",
	"Ascension",
	"Finale",
	"res://main/end_screen.tscn"#not shown
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.level_select_entry:
		GameState.level_select_entry = false
		$Level.text = "Level " + str(GameState.current_level)
		$Title.text = LEVEL_NAME[GameState.current_level - 1]
		await get_tree().create_timer(0.3).timeout
		$AnimationPlayer.play("show_title")
