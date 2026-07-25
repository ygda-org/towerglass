extends CharacterBody2D

const GRAVITY = 450
@export var gravity_curve_asc: Curve
@export var gravity_curve_dec: Curve
const MAX_FALL_SPEED = 500

const MAX_JUMP = -250
const MAX_JUMP_CHARGE = 0.5
var total_sand: float = 6.0
@onready var sand_in_bottom: float = total_sand/2
##Either "yellow" or "blue
var sand_bottom_col : String = "yellow"
var jump_charge = 0.0
var camera_offset: Vector2 = Vector2.ZERO
var camera_offset_follow: float = 0.0
@export var jump_charge_curve: Curve

const MAX_SPEED = 150
const AIR_FRICTION = 0.99
const AIR_CONTROL = 500
@export var aerial_acceleration_curve: Curve

const DRAG_SPEED = 20
const MAX_DRAG_SPEED_BOOST = 6
var drag_speed_boost = 0

signal jumped
signal died

var god_mode = false

@onready var sand : AnimatedSprite2D = $Mask/Sand
@onready var mask_tex : GradientTexture2D = $Mask.texture
@onready var mask_grad : Gradient = mask_tex.gradient
var left_floor : Object = null
var right_floor : Object = null

var was_on_floor : bool = false

var is_physics_process : bool = true

var has_moved: bool = false

var camera_center_position = Vector2(0,0)
var camera_target_offset = Vector2(0,0)
var sway_dir = 1

func _ready() -> void:
	GameState.player = self
	GameState.last_location = global_position
	$Anim.play("default")
	sand.play("yellow_idle")
	
	SFX.play(SFX.Labels.LEVELTRANSITION)
	await get_tree().create_timer(0.6).timeout
	SFX.play(SFX.Labels.LEVELSTART)


func _physics_process(delta: float):
		
	if not is_physics_process:
		return
	
	was_on_floor = is_on_floor()
	
	if is_on_floor() and velocity.x != 0:
		has_moved = true
		SFX.play(SFX.Labels.WALK)
	else:
		SFX.clear_audio(SFX.Labels.WALK)
		
	if Input.is_action_just_released("jump") and is_on_floor():
		SFX.play(SFX.Labels.TOWERCROSSWHOOSH)
		#SFX.play(SFX.Labels.FLIP)
		SFX.play(SFX.Labels.FLIPSANDFALL)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		SFX.play(SFX.Labels.JUMPCHARGE)
	else:
		SFX.clear_audio(SFX.Labels.JUMPCHARGE)
		
	if Input.is_action_just_pressed("god_mode"):
		god_mode = not god_mode
		print("god mode :", god_mode)
		sand_in_bottom = 0.0
		
	if Input.is_action_just_pressed("reset"):
		die()
	
	if $JumpJuice.is_stopped():
		camera_center_position = global_position + Vector2(0, 15*jump_charge/MAX_JUMP_CHARGE)
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(2, 2)+Vector2(0.2,0.2)*jump_charge/MAX_JUMP_CHARGE, delta)
	else:
		$Camera2D.position_smoothing_speed = 2
		camera_center_position = global_position + Vector2(0, -100*velocity.y/MAX_JUMP)
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(2, 2)-Vector2(0.2,0.2)*velocity.y/MAX_JUMP,delta*7)
	$Camera2D.offset = $Camera2D.offset.lerp(camera_offset * camera_offset_follow, delta/3)
	
	# swaying
	if jump_charge == MAX_JUMP_CHARGE:
		$Camera2D.position_smoothing_speed = 5
		if ($Camera2D.global_position-camera_center_position).distance_to(camera_target_offset) < 2:
			camera_target_offset = Vector2(randf_range(20,25)*sway_dir, randf_range(-5,5))
			sway_dir *= -1
	else:
		camera_target_offset = Vector2(0,0)
	$Camera2D.global_position = camera_center_position + camera_target_offset
	
	if $CameraOffsetDetection.has_overlapping_areas():
		camera_offset_follow += delta
	else:
		camera_offset_follow -= delta
	camera_offset_follow = clamp(camera_offset_follow, 0, 1)
	#$Sprite2D.modulate = Color(jump_charge/MAX_JUMP_CHARGE, 0.0, 0.0, 1.0)
	$Placeholder.text = str(round(sand_in_bottom / total_sand * 100)) + "%"
	var dir = Input.get_axis("left", "right")
	if is_on_floor():
		drag_speed_boost = move_toward(drag_speed_boost, 1.0, delta*3)
		poll_floor_type()
		#Sticky Platform Check
		var jump_offset : int = 0
		var walk_offset : int = 0
		if ($StickyLeft.get_collider() != null) or ($StickyRight.get_collider() != null):
			jump_offset = 200
		else:
			jump_offset = 0
		
		velocity.x = (DRAG_SPEED - walk_offset) * dir * drag_speed_boost
		$Camera2D.position_smoothing_speed = 4.0
		if Input.is_action_pressed("jump"):
			$Anim.play("squash")
			mask_tex.height = 14 - $Anim.frame - 1
			$Mask.position.y = $Anim.frame + 1
			sand.play(sand_bottom_col + "_squash")
			velocity.x = 0
			jump_charge = move_toward(jump_charge, MAX_JUMP_CHARGE, delta)
		elif Input.is_action_just_released("jump"):
			mask_tex.height = 14
			$Mask.position.y = 0
			velocity.y = -up_direction.y * (MAX_JUMP + jump_offset) * jump_charge_curve.sample(jump_charge/MAX_JUMP_CHARGE)
			flip()
			$JumpJuice.wait_time = jump_charge
			jump_charge = 0.0
			$JumpJuice.start()
			GameState.player_jumped.emit()
	else:
		left_floor = null
		right_floor = null
		$Camera2D.position_smoothing_speed = 1.0
		if dir * velocity.x <= 0:
			velocity.x *= AIR_FRICTION
		velocity.x = move_toward(velocity.x, MAX_SPEED * dir, AIR_CONTROL * delta * aerial_acceleration_curve.sample(abs(velocity.x/MAX_SPEED)))
		var grav_mult
		if -velocity.y*up_direction.y > 0:
			grav_mult = gravity_curve_dec.sample(abs(velocity.y)/MAX_FALL_SPEED)
		else:
			grav_mult = gravity_curve_asc.sample(abs(velocity.y)/MAX_JUMP)
		if god_mode:
			grav_mult = 0.5

		velocity.y = move_toward(velocity.y, -up_direction.y * MAX_FALL_SPEED, delta*GRAVITY*grav_mult)
		
	move_and_slide()
	
	if not was_on_floor and is_on_floor():
		SFX.play(SFX.Labels.HOURGLASSFALL)
	
	update_sand(delta)

func set_gravity(dir):
	up_direction = Vector2(0,-dir)

func update_sand(delta : float):
	if "flip" in $Anim.animation and $Anim.is_playing():
		return
		
	if has_moved == false:
		return
	
	sand_in_bottom += delta
	$CanvasLayer/Vignette.self_modulate.a = (sand_in_bottom / total_sand)**2
	update_sand_visual()
	
	if sand_in_bottom >= total_sand:
		die()

func update_sand_visual():
	var points : Array[float] = [0,0,0.5,0.5,1.0,1.0]
	var percent : float = sand_in_bottom / total_sand
	points[0] = 0.5 * percent
	points[1] = 0.5 * percent
	points[4] = 0.5 * (1 - percent) + 0.5
	points[5] = 0.5 * (1 - percent) + 0.5
	
	mask_grad.offsets = PackedFloat32Array(points)

func poll_floor_type():
	left_floor = $LeftRay.get_collider()
	right_floor = $RightRay.get_collider()

func flip():
	drag_speed_boost = MAX_DRAG_SPEED_BOOST * jump_charge_curve.sample(jump_charge/MAX_JUMP_CHARGE)
	if Input.is_action_pressed("left"):
		$Anim.play("left_flip")
		sand.flip_h = true
	else:
		$Anim.play("flip")
		sand.flip_h = false
	sand.play(sand_bottom_col + "_flip")
	if sand_bottom_col == "yellow":
		sand_bottom_col = "blue"
	else:
		sand_bottom_col = "yellow"
	sand_in_bottom = total_sand - sand_in_bottom
	update_sand_visual()
	var tween : Tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/Vignette, "self_modulate", Color(1.0,1.0,1.0,(sand_in_bottom / total_sand)**2), 0.5)
	await sand.animation_finished
	sand.flip_h = false

func damage(dmg: float) -> void:
	total_sand -= dmg
	sand_in_bottom = min(sand_in_bottom, total_sand)
	$HitParticle.emitting = true
	$HitParticle.emitting = false
	
func die() -> void:
	has_moved = false
	if $DeathCooldown.time_left > 0.0:
		return
	
	if god_mode == true:
		return
		
	$DeathCooldown.start()
	
	position = GameState.last_location
	velocity = Vector2.ZERO
	total_sand = 6.0
	sand_in_bottom = total_sand/2
	died.emit()

func _on_hurtbox_body_entered(body):
	SFX.play(SFX.Labels.DEATHSPILL)
	die()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not $Down.is_colliding():
		die()
