extends StaticBody2D

const BULLET = preload("uid://d5m3kp8lwgis")

## MUST be "north", "south", "west", "east"
@export var orientation : String = "west"
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

@export var bullet_parent_amount: int = 1

var current_direction_index = 0
var iter_dir = 1

var player_visible: bool = false

func _ready():
	match orientation:
		"north":
			$Body.region_rect.position.y = 32
		"south":
			pass
		"east":
			$Body.region_rect.position.x = 32
		"west":
			$Body.region_rect.position.x = 32
			$Body.region_rect.position.y = 32
	$BarrelPivot.rotation = shot_directions[0].angle()
	$RotateTurret.frame = rotation_to_frame(shot_directions[0].angle())
	await get_tree().create_timer(0.5).timeout
	shoot()

func rotation_to_frame(rotation : float) -> int:
	return int(round(remap(rotation, 0, 2*PI, 0, 12)))

func shoot():
	if $RotateTurret.frame >= 12:
		$RotateTurret.frame = $RotateTurret.frame % 12
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
	if abs($BarrelPivot.rotation - next_angle) > PI:
		next_angle += 2*PI
	print(rotation_to_frame(next_angle), "\t", next_angle)
	tween.tween_property($BarrelPivot, "rotation", next_angle, shot_time)
	tween.tween_callback(pause.call_deferred)
	var rotate_tween = get_tree().create_tween()
	rotate_tween.tween_property($RotateTurret, "frame", rotation_to_frame(next_angle), shot_time)
	current_direction_index = next_direction_index

func pause():
	await get_tree().create_timer(pause_time/2).timeout
	var bullet = BULLET.instantiate()
	bullet.velocity = shot_directions[current_direction_index]
	bullet.position = $BarrelPivot/BulletSpawn.global_position
	if $BarrelPivot.rotation > 0.0:
		SFX.play(SFX.Labels.TURRETTURN)
	else:
		SFX.clear_audio(SFX.Labels.TURRETTURN)
	bullet.rotation = $BarrelPivot.rotation
	var parent = self
	for i in range(bullet_parent_amount):
		parent = parent.get_parent()
	parent.add_child(bullet)
	if player_visible == true:
		SFX.play(SFX.Labels.BULLETSHOOT)
		SFX.clear_audio(SFX.Labels.TURRETTURN)
	
	$RotateTurret.visible = false
	$ShootTurret.visible = true
	$ShootTurret.speed_scale = 1/(pause_time/2)
	match ($RotateTurret.frame % 12):
		0:
			$ShootTurret.play("east_shoot")
		3:
			$ShootTurret.play("south_shoot")
		6:
			$ShootTurret.play("west_shoot")
		9:
			$ShootTurret.play("north_shoot")
	
	await get_tree().create_timer(pause_time/2).timeout
	$RotateTurret.visible = true
	$ShootTurret.visible = false
	shoot()

func _on_visible_on_screen_notifier_2d_screen_entered():
	player_visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	player_visible = false
