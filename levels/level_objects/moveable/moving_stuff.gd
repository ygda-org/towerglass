@tool
extends Path2D


@export var time: float = 1.0
@export var wait_until_player_touches_to_move: bool = false
@export var go_back: bool = true
@export var return_quickly: bool = false
@export var trans_type: Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
var progress: float
var elapsed_time: float = 0
var flip = false
var moving = true

var child_deltas = {}

func _ready() -> void:
	var points = curve.get_baked_points()
	$Line2D.points = points
	update_children()
	GameState.player.died.connect(reset)
	if wait_until_player_touches_to_move:
		moving = false
		for child in get_children():
			if child.name == "MoveablePlatform":
				child.touched_player.connect(start_move)

func _physics_process(delta: float) -> void:
	if not moving:
		return
	var timer_ratio = Tween.interpolate_value(0.0, 1.0, elapsed_time, time, trans_type, ease_type)
	if flip:
		$PathFollow2D.progress_ratio = 1 - timer_ratio
	else:
		$PathFollow2D.progress_ratio = timer_ratio
	update_children()
	elapsed_time += delta * 2
	if return_quickly and $PathFollow2D.global_position.distance_to(GameState.player.global_position) > 150:
		elapsed_time += delta * 2
	if elapsed_time > time:
		if go_back:
			elapsed_time -= time
			
			flip = not flip
			if return_quickly and not flip:
				moving = false
				for child in get_children(true):
					if child.name == "MoveablePlatform":
						child.moving = false
		else:
			elapsed_time = time

func start_move() -> void:
	moving = true

func reset():
	elapsed_time = 0
	flip = false
	if wait_until_player_touches_to_move:
		for child in get_children(true):
			if child.name == "MoveablePlatform":
				child.moving = false
		moving = false
	$PathFollow2D.progress_ratio = 0
	update_children()

func update_children() -> void:
	for child in get_children():
		if child is Node2D and child is not Line2D:
			child.position = $PathFollow2D.position
