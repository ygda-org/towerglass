extends Area2D


@export var smoothing: float = 10

func _on_body_entered(body):
	body.camera_smoothing_override = smoothing


func _on_body_exited(body):
	body.camera_smoothing_override = 0
