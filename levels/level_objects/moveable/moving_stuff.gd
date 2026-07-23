extends Path2D


@export var time: float = 1.0
@export var wait_until_player_touches_to_move: bool = false
var progress: float
var elapsed_time: float = 0
var flip = false

func _physics_process(delta: float) -> void:
	
	var timer_ratio = Tween.interpolate_value(0.0, 1.0, elapsed_time, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	if flip:
		$PathFollow2D.progress_ratio = 1 - timer_ratio
	else:
		$PathFollow2D.progress_ratio = timer_ratio
	for child in get_children():
		if child is Node2D:
			child.position = $PathFollow2D.position
	elapsed_time += delta * 2
	if elapsed_time > time:
		elapsed_time -= time
		flip = not flip
