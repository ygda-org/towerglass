extends CharacterBody2D

const GRAVITY = 450

var max_jump = -300
var max_jump_charge = 0.5
var jump_charge = 0.0
@export var jump_charge_curve: Curve

const MAX_SPEED = 150

func _ready() -> void:
	GameState.player = self

func _physics_process(delta: float):
	if is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("jump"):
			jump_charge = move_toward(jump_charge, max_jump_charge, delta)
		elif Input.is_action_just_released("jump"):
			velocity.y = max_jump * jump_charge_curve.sample(jump_charge/max_jump_charge)
			jump_charge = 0.0
	else:
		var dir = Input.get_axis("left", "right")
		velocity.x = MAX_SPEED * dir
		velocity.y += GRAVITY * delta # add curve later
	move_and_slide()
