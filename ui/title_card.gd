extends Control

const LEVEL_NAME = [
	"Beginnings",
	"Movement",
	"res://levels/crumbling.tscn",
	"res://levels/on_off.tscn",
	"res://levels/turrets_level.tscn",
	"Touch And Go",
	"Aww Rats",
	"Trampoline",
	"Best Buds",
	"The Tower",
	"res://levels/motion_turrets.tscn",
	"Limits",
	"Ascension",
	"Finale",
	"res://main/end_screen.tscn"
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate.a = 0.0
	$Title.modulate.a = 0.0
	if GameState.level_select_entry:
		$Level.text = "Level " + str(GameState.current_level)
		$Title.text = LEVEL_NAME[GameState.current_level - 1]
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 3)
		tween.tween_property($Title, "modulate", Color(1.0,1.0,1.0,1.0), 1.5)
		tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.5)
		await tween.finished
		GameState.level_select_entry = false
