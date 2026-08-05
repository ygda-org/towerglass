extends Control

func _ready():
	if GameState.reset_level_select_music == true:
		SFX.force_clear_audios()
		Music.start(Music.Labels.SELECT)
	GameState.reset_level_select_music = true

func _on_skip_pressed():
	SFX.play(SFX.Labels.BUTTONCLICK)
	GameState.max_level_beaten += 1
	GameState.reset_level_select_music = false
	get_tree().change_scene_to_file("uid://bn6f701wdg7wr")


func _on_skip_mouse_entered():
	SFX.play(SFX.Labels.BUTTONHOVER)
