extends Control
@onready var ygda_logo = $YGDALogo
@onready var ygda_logo_sprite = $YGDALogo/YGDALogoSprite
@onready var color_rect = $YGDALogo/ColorRect

@onready var play_button = $MainMenu/PlayButton
@onready var credits_button = $MainMenu/CreditsButton
@onready var settings_button = $MainMenu/SettingsButton

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

func _process(delta):
	$Wheel.rotation += deg_to_rad(5) * delta

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
	SFX.play(SFX.Labels.BUTTONCLICK)


func _on_credits_button_pressed():
	SFX.play(SFX.Labels.BUTTONCLICK)

func _on_play_button_pressed():
	SceneSwitcher.go_to_scene("res://ui/level_select.tscn")
	SFX.play(SFX.Labels.BUTTONCLICK)


func _on_play_button_mouse_entered():
		SFX.play(SFX.Labels.BUTTONHOVER)


func _on_credits_button_mouse_entered():
		SFX.play(SFX.Labels.BUTTONHOVER)


func _on_settings_button_mouse_entered():
		SFX.play(SFX.Labels.BUTTONHOVER)
