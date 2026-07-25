extends Area2D

var activated : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_body_entered(body: Node2D) -> void:
	if body == GameState.player and not activated:
		#GameState.player.process_mode = Node.PROCESS_MODE_DISABLED
		GameState.player.is_physics_process = false
		activated = true
		GameState.update_max_level_beaten()
		super_cool_exit_animation()


func super_cool_exit_animation():
	var initial_length : float = 4.75
	
	GameState.player.sand.play("default")
	GameState.player.find_child("Anim").play("default")
	$InwardStar.emitting = true
	SFX.play(SFX.Labels.WINDUPSPARKLE)
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(GameState.player, "global_position", global_position + Vector2(0,2), initial_length)
	var tween2 : Tween = get_tree().create_tween()
	tween2.tween_property($Clock, "self_modulate", Color(1.0,1.0,1.0,1.0), initial_length)
	GameState.player.find_child("Camera2D").position = Vector2.ZERO
	GameState.player.find_child("Camera2D").align()
	$Clock.speed_scale = 1/initial_length
	$Clock.play("clock_spin")
	#var tween2 : Tween = get_tree().create_tween()
	#tween.tween_property(GameState.player.find_child("Camera2D"), "global_position", global_position + Vector2(0,3), 5)
	await tween.finished
	$Clock.visible = false
	$InwardStar.visible = false
	GameState.player.visible = false
	$Explosion.emitting = true
	await get_tree().create_timer(1).timeout
	SceneSwitcher.go_to_scene("res://ui/level_select.tscn")
