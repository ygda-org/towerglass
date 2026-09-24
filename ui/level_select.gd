extends Control

const NameBox = preload("uid://ba3h4ilsy52b")

func _ready():
	if GameState.reset_level_select_music == true:
		SFX.force_clear_audios()
		Music.start(Music.Labels.SELECT)
	GameState.reset_level_select_music = true
	if Leaderboard.new_best_time != -1:
		var box = NameBox.instantiate()
		add_child(box)
		box.grab_focus()
		await box.name_entered
		Leaderboard.names[Leaderboard.current_level][Leaderboard.new_best_time] = box.entered_name
		Leaderboard.save()
		Leaderboard.new_best_time = -1
	$Buttons.get_children()[0].grab_focus()

func _on_skip_pressed():
	SFX.play(SFX.Labels.BUTTONCLICK)
	GameState.max_level_beaten += 1
	GameState.reset_level_select_music = false
	get_tree().change_scene_to_file("uid://bn6f701wdg7wr")


func _on_skip_mouse_entered():
	SFX.play(SFX.Labels.BUTTONHOVER)
