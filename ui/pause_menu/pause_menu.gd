extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	create_bitmap($ExitButton)
	create_bitmap($LevelSelectButton)
	
	$MasterSlider/MasterHSlider.value = GameState.master_volume
	$MusicSlider/MusicHSlider.value = GameState.music_volume
	$SFXSlider/SFXHSlider.value = GameState.sfx_volume
	$AmbienceSlider/AmbienceHSlider.value = GameState.ambience_volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	if not visible:
		return
	SFX.force_pause_audios()
	SFX.play_audios(SFX.Labels.BUTTONCLICK)
	SFX.play_audios(SFX.Labels.BUTTONHOVER)

func _on_level_select_button_pressed():
	SFX.play(SFX.Labels.BUTTONCLICK)
	SceneSwitcher.go_to_scene("res://ui/level_select.tscn")
	if self:
		SFX.force_clear_audios()
	toggle_pause()

func _on_exit_button_pressed():
	SFX.play(SFX.Labels.BUTTONCLICK)
	toggle_pause()

func toggle_pause():
	if get_tree().paused == true:
		SFX.force_play_audios()
	if get_tree().paused == false:
		SFX.force_pause_audios()
		
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

func _on_master_h_slider_value_changed(value):
	change_bus_volume("Master", value)


func _on_music_h_slider_value_changed(value):
	change_bus_volume("Music", value)


func _on_sfxh_slider_value_changed(value):
	change_bus_volume("SFX", value)
	
func _on_ambience_h_slider_value_changed(value):
	change_bus_volume("Ambience", value)

func change_bus_volume(bus, linear_value):
	if bus == "Master":
		GameState.master_volume = linear_value
	if bus == "Music":
		GameState.music_volume = linear_value
	if bus == "SFX":
		GameState.sfx_volume = linear_value
	if bus == "Ambience":
		GameState.ambience_volume = linear_value
	
	var db_value = linear_to_db(linear_value)
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, db_value)
	
func create_bitmap(button):
	if button.texture_normal:
		# Get the image from the texture normal
		var image = button.texture_normal.get_image()
		# Create the BitMap
		var bitmap = BitMap.new()
		# Fill it from the image alpha
		bitmap.create_from_image_alpha(image)
		# Assign it to the mask
		button.texture_click_mask = bitmap

func _on_exit_button_mouse_entered():
	SFX.play(SFX.Labels.BUTTONHOVER)

func _on_level_select_button_mouse_entered():
	SFX.play(SFX.Labels.BUTTONHOVER)
