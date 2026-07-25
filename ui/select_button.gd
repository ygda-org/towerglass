extends TextureButton

@export var number : int = 0
@export var target : String

@export var level_song: Music.Labels = Music.Labels.EARLY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Number.text = str(number)

func _on_pressed() -> void:
	SFX.play(SFX.Labels.BUTTONCLICK)
	Music.start(level_song)
	SceneSwitcher.go_to_scene(target)


func _on_mouse_entered():
		SFX.play(SFX.Labels.BUTTONHOVER)
