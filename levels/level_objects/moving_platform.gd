extends Path2D


@export var time: int

func _ready() -> void:
	$Timer.wait_time = time
	$Timer.start()

func _physics_process(delta: float) -> void:
	if $Timer.time_left > $Timer.wait_time / 2:
		$PathFollow2D.progress_ratio = $Timer.wait_time / 2 - ($Timer.time_left - $Timer.wait_time / 2) 
	else:
		$PathFollow2D.progress_ratio = $Timer.time_left
	$AnimatableBody2D.position = $PathFollow2D.position
