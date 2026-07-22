extends Path2D


@export var time: int

func _ready() -> void:
	$Timer.wait_time = time
	$Timer.start()

func _physics_process(delta: float) -> void:
	var timer_ratio = clamp(1 - ($Timer.time_left / $Timer.wait_time), 0, 1)
	if timer_ratio > 0.5:
		$PathFollow2D.progress_ratio = (1 - timer_ratio) * 2
	else:
		$PathFollow2D.progress_ratio = timer_ratio * 2
	$AnimatableBody2D.position = $PathFollow2D.position
