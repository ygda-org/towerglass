extends Node2D

func _on_texture_button_pressed():
	SFX.play(SFX.Labels.BUTTONCLICK)
	SceneSwitcher.go_to_scene("res://ui/start_menu.tscn", SceneSwitcher.TYPE.FADE)


func _on_texture_button_mouse_entered():
	SFX.play(SFX.Labels.BUTTONHOVER)
