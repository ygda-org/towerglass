extends Control
@onready var ygda_logo = $YGDALogo
@onready var ygda_logo_sprite = $YGDALogo/YGDALogoSprite
@onready var color_rect = $YGDALogo/ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
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


func _on_start_button_pressed():
	pass # Replace with function body.
