extends Area2D

func _physics_process(delta: float) -> void:
	if has_overlapping_bodies():
		GameState.player.get_node("Camera2D").offset.y -= delta * 142
	else:
		GameState.player.get_node("Camera2D").offset.y += delta * 142
	GameState.player.get_node("Camera2D").offset.y = clamp(GameState.player.get_node("Camera2D").offset.y, -142, 0)
