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

func _ready() -> void:
	GameState.player = self
	GameState.last_location = global_position
	$Anim.play("default")
	sand.play("yellow_idle")
	
	SFX.play(SFX.Labels.LEVELTRANSITION)
	await get_tree().create_timer(0.6).timeout
	SFX.play(SFX.Labels.LEVELSTART)


func _physics_process(delta: float):
	
	was_on_floor = is_on_floor()
	
	if is_on_floor() and velocity.x != 0:
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
		
	#$Sprite2D.modulate = Color(jump_charge/MAX_JUMP_CHARGE, 0.0, 0.0, 1.0)
	$Placeholder.text = str(round(sand_in_bottom / total_sand * 100)) + "%"
	drag_speed_boost = move_toward(drag_speed_boost, 1.0, delta*2)
	var dir = Input.get_axis("left", "right")
	if is_on_floor():
		poll_floor_type()
		#Sticky Platform Check
		var jump_offset : int = 0
		var walk_offset : int = 0
		if (left_floor and "Sticky" in left_floor.name) or (right_floor and "Sticky" in right_floor.name):
			jump_offset = 100
			walk_offset = 10
		
		velocity.x = (DRAG_SPEED - walk_offset) * dir * drag_speed_boost
		$Camera2D.position_smoothing_speed = 4.0
		$Camera2D.global_position = global_position
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
			velocity.y = (MAX_JUMP + jump_offset) * jump_charge_curve.sample(jump_charge/MAX_JUMP_CHARGE)
			jump_charge = 0.0
			flip()
			GameState.player_jumped.emit()
	else:
		$Camera2D.position_smoothing_speed = 1.0
		if dir * velocity.x <= 0:
			velocity.x *= AIR_FRICTION
		velocity.x = move_toward(velocity.x, MAX_SPEED * dir, AIR_CONTROL * delta * aerial_acceleration_curve.sample(abs(velocity.x/MAX_SPEED)))
		var grav_mult
		if velocity.y > 0:
			grav_mult = gravity_curve_dec.sample(velocity.y/MAX_FALL_SPEED)
		else:
			grav_mult = gravity_curve_asc.sample(velocity.y/MAX_JUMP)
		velocity.y = move_toward(velocity.y, MAX_FALL_SPEED, delta*GRAVITY*grav_mult)
	move_and_slide()
	
	if not was_on_floor and is_on_floor():
		SFX.play(SFX.Labels.HOURGLASSFALL)
	
	update_sand(delta)

func update_sand(delta : float):
	if "flip" in $Anim.animation and $Anim.is_playing():
		return
	
	sand_in_bottom += delta
	
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
	drag_speed_boost = MAX_DRAG_SPEED_BOOST
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
	await sand.animation_finished
	sand.flip_h = false

func damage(dmg: float) -> void:
	total_sand -= dmg
	sand_in_bottom = min(sand_in_bottom, total_sand)
	$HitParticle.emitting = true
	$HitParticle.emitting = false
	
func die() -> void:
	if $DeathCooldown.time_left > 0.0:
		return
	
	if god_mode == true:
		return
		
	$DeathCooldown.start()
	
	position = GameState.last_location
	total_sand = 6.0
	sand_in_bottom = total_sand/2
	died.emit()

func _on_hurtbox_body_entered(body):
	SFX.play(SFX.Labels.DEATHSPILL)
	die()
