extends StaticBody2D

const BULLET = preload("uid://d5m3kp8lwgis")

## If on, the turret will not rotate. Conflicts with harmonic
## Shot_time will do nothing
@export var is_one_direction : bool = false
## array of vector2 that indicate all directions the turret will shoot at
@export var shot_directions: Array[Vector2]
## if true, turret traverses list backwards after shooting last direction. Otherwise loops back to the start
@export var harmonic: bool = false
## time between shots
@export var shot_time: float = 1.0
## time paused between shots
@export var pause_time : float = 1.0

var current_direction_index = 0
var iter_dir = 1

func _ready():
	$BarrelPivot.rotation = shot_directions[0].angle()
	await get_tree().create_timer(0.5).timeout
	shoot()

func shoot():
	if is_one_direction:
		pause()
		return
	if $BarrelPivot.rotation >= 2*PI:
		$BarrelPivot.rotation -= 2*PI
	$BarrelPivot.rotation = wrapf($BarrelPivot.rotation, -180, 180)
	if harmonic and (current_direction_index == 0 or current_direction_index == len(shot_directions)-1):
		iter_dir *= -1
	var tween = get_tree().create_tween()
	var next_direction_index = (current_direction_index + iter_dir) % len(shot_directions)
	var next_angle = shot_directions[next_direction_index].angle()
	print($BarrelPivot.rotation, next_angle)
	if abs($BarrelPivot.rotation - next_angle) > PI:
		next_angle += 2*PI
	tween.tween_property($BarrelPivot, "rotation", next_angle, shot_time)
	tween.tween_callback(pause.call_deferred)
	current_direction_index = next_direction_index

func pause():
	await get_tree().create_timer(pause_time/2).timeout
	var bullet : CharacterBody2D = BULLET.instantiate()
	bullet.velocity = shot_directions[current_direction_index]
	bullet.position = $BarrelPivot/BulletSpawn.global_position
	get_parent().add_child(bullet)
	await get_tree().create_timer(pause_time/2).timeout
	shoot()
