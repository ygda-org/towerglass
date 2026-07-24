extends Area2D

@export var offset_amount: Vector2
func _physics_process(delta: float) -> void:
	if has_overlapping_bodies():
		GameState.player.camera_offset = offset_amount
