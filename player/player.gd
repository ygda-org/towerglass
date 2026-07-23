extends CharacterBody2D

const GRAVITY = 450
@export var gravity_curve_asc: Curve
@export var gravity_curve_dec: Curve
const MAX_FALL_SPEED = 500

const MAX_JUMP = -300
const MAX_JUMP_CHARGE = 0.5
var total_sand: float = 6.0
@onready var sand_in_bottom: float = total_sand/2
var jump_charge = 0.0
var died = false
@export var jump_charge_curve: Curve

const MAX_SPEED = 150
const AIR_FRICTION = 0.99
const AIR_CONTROL = 500
@export var aerial_acceleration_curve: Curve

signal jumped

func _ready() -> void:
	GameState.player = self
	GameState.last_location = global_position

func _physics_process(delta: float):
	$Sprite2D.modulate = Color(jump_charge/MAX_JUMP_CHARGE, 0.0, 0.0, 1.0)
	$Placeholder.text = str(round(sand_in_bottom / total_sand * 100)) + "%"
	if is_on_floor():
		$Camera2D.position_smoothing_speed = 4.0
		$Camera2D.global_position = global_position
		velocity.x = 0
		if Input.is_action_pressed("jump"):
			jump_charge = move_toward(jump_charge, MAX_JUMP_CHARGE, delta)
		elif Input.is_action_just_released("jump"):
			velocity.y = MAX_JUMP * jump_charge_curve.sample(jump_charge/MAX_JUMP_CHARGE)
			jump_charge = 0.0
			flip()
			GameState.player_jumped.emit()
	else:
		$Camera2D.position_smoothing_speed = 1.0
		var dir = Input.get_axis("left", "right")
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
	
	sand_in_bottom += delta
	if sand_in_bottom >= total_sand:
		die()

func flip():
	sand_in_bottom = total_sand - sand_in_bottom

func damage(dmg: int) -> void:
	total_sand -= dmg
	sand_in_bottom = min(sand_in_bottom, total_sand)
	
func die() -> void:
	if not died:
		died = true
		print('i am become dead')
	position = GameState.last_location
	sand_in_bottom = total_sand/2
