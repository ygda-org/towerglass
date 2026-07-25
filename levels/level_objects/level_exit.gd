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
		super_cool_exit_animation()


func super_cool_exit_animation():
	GameState.player.sand.play("default")
	GameState.player.find_child("Anim").play("default")
	$InwardStar.emitting = true
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(GameState.player, "global_position", global_position + Vector2(0,2), 5)
	GameState.player.find_child("Camera2D").position = Vector2.ZERO
	GameState.player.find_child("Camera2D").align()
	#var tween2 : Tween = get_tree().create_tween()
	#tween.tween_property(GameState.player.find_child("Camera2D"), "global_position", global_position + Vector2(0,3), 5)
	await tween.finished
	$InwardStar.restart()
	$InwardStar.emitting = false
	GameState.player.visible = false
	$Explosion.emitting = true
	await get_tree().create_timer(1).timeout
	SceneSwitcher.go_to_scene("res://ui/level_select.tscn")
