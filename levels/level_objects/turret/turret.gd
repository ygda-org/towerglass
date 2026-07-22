extends StaticBody2D

## array of vector2 that indicate all directions the turret will shoot at
@export var shot_directions: Array[Vector2]
## if true, turret traverses list backwards after shooting last direction. Otherwise loops back to the start
@export var harmonic: bool = false
## time between shots
@export var shot_time: float = 1.0

var current_direction_index = 0
var iter_dir = 1

func _ready():
	$BarrelPivot.rotation = shot_directions[0].angle()
	shoot()

func shoot():
	print(shot_directions[current_direction_index])
	$BarrelPivot.rotation = wrapf($BarrelPivot.rotation, -180, 180)
	if harmonic and current_direction_index == 0 or current_direction_index == len(shot_directions)-1:
		iter_dir *= -1
	var tween = get_tree().create_tween()
	var next_direction_index = (current_direction_index + iter_dir) % len(shot_directions)
	var next_angle = shot_directions[next_direction_index].angle()
	if abs(signf(next_angle)*PI*2-next_angle - $BarrelPivot.rotation) < abs(next_angle - $BarrelPivot.rotation):
		next_angle = signf(next_angle)*PI*2-next_angle
	tween.tween_property($BarrelPivot, "rotation", next_angle, shot_time)
	tween.tween_callback(shoot.call_deferred)
	current_direction_index = next_direction_index
