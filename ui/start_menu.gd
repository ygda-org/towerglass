extends Control
@onready var ygda_logo = $YGDALogo
@onready var ygda_logo_sprite = $YGDALogo/YGDALogoSprite
@onready var color_rect = $YGDALogo/ColorRect

@onready var play_button = $MainMenu/PlayButton
@onready var credits_button = $MainMenu/CreditsButton
@onready var settings_button = $MainMenu/SettingsButton

var elapsed_time : float = 0

var intro_playing = true

# Called when the node enters the scene tree for the first time.
func _ready():
	create_bitmap(play_button)
	create_bitmap(credits_button)
	create_bitmap(settings_button)

	ygda_logo.visible = true
	ygda_logo_sprite.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	SFX.play(SFX.Labels.YGDASTING)
	var tween_opening = get_tree().create_tween()
	tween_opening.tween_property(ygda_logo_sprite, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 1.0).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1.41).timeout
	ygda_logo_sprite.play("default")
	await get_tree().create_timer(2.59).timeout
	var tween_closing = get_tree().create_tween()
	tween_closing.tween_property(ygda_logo_sprite, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0).set_trans(Tween.TRANS_SINE)
	tween_closing.parallel().tween_property(color_rect, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1.41).timeout 
	ygda_logo.visible = false
	
	#INTRO CUTSCENE
	Music.start(Music.Labels.DEATH)
	#$IntroCutscene/Still1.visible = false
	$IntroCutscene/Vid1.play()	
	await $IntroCutscene/Vid1.finished
	await get_tree().create_timer(0.5).timeout
	
	$IntroCutscene/Still1.visible = false
	$IntroCutscene/Vid1.visible = false
	
	$IntroCutscene/Back2.visible = true
	$IntroCutscene/Front2.visible = true
	
	var tween1 : Tween = get_tree().create_tween()
	tween1.tween_property($IntroCutscene/Back2, "position", Vector2(0,0), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var tween2 : Tween = get_tree().create_tween()
	tween2.tween_property($IntroCutscene/Front2, "position", Vector2(-40,0), 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween2.finished
	
	$IntroCutscene/Back2.visible = false
	$IntroCutscene/Front2.visible = false
	
	$IntroCutscene/Vid3.play()
	await $IntroCutscene/Vid3.finished
	await get_tree().create_timer(0.5).timeout
	var tween3 : Tween = get_tree().create_tween()
	tween3.tween_property($IntroCutscene/Sand4, "self_modulate", Color(1.0,1.0,1.0,1.0), 2)#.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween3.finished
	
	var tween_final : Tween = get_tree().create_tween()
	tween_final.tween_property($IntroCutscene, "modulate", Color(1.0,1.0,1.0,0.0), 2)#.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween_final.finished
	$IntroCutscene.visible = false
	
	intro_playing = false
	Music.start(Music.Labels.TITLE)

func _process(delta):
	$Wheel.rotation += deg_to_rad(5) * delta
	$MainArt.rotation_degrees = 1.1 * sin(1.5 * elapsed_time)
	elapsed_time += delta

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

func _on_settings_button_pressed():
	if not intro_playing:
		SFX.play(SFX.Labels.BUTTONCLICK)
		$CanvasLayer/PauseMenu.toggle_pause()
		#$CanvasLayer/PauseMenu/LevelSelectButton.visible = false

func _on_credits_button_pressed():
	if not intro_playing:
		SFX.play(SFX.Labels.BUTTONCLICK)
		var tween : Tween = get_tree().create_tween()
		tween.tween_property($Credits, "position", Vector2(190.0, 100.0), 1).set_trans(Tween.TRANS_SINE)

func _on_play_button_pressed():
	if not intro_playing:
		SceneSwitcher.go_to_scene("res://ui/level_select.tscn")
		SFX.play(SFX.Labels.BUTTONCLICK)


func _on_play_button_mouse_entered():
	if not intro_playing:
		SFX.play(SFX.Labels.BUTTONHOVER)

func _on_credits_button_mouse_entered():
	if not intro_playing:
		SFX.play(SFX.Labels.BUTTONHOVER)

func _on_settings_button_mouse_entered():
	if not intro_playing:
		SFX.play(SFX.Labels.BUTTONHOVER)


func _on_credit_back_pressed() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property($Credits, "position", Vector2(190.0, 560), 1).set_trans(Tween.TRANS_SINE)
