extends Area2D

func _physics_process(delta: float) -> void:
	if has_overlapping_bodies():
		GameState.player.get_node("Camera2D").offset.y -= delta * 100
	else:
		GameState.player.get_node("Camera2D").offset.y += delta * 100
	GameState.player.get_node("Camera2D").offset.y = clamp(GameState.player.get_node("Camera2D").offset.y, -128, 0)
