extends CharacterBody2D

const GRAVITY = 450

const MAX_JUMP = -300
const MAX_JUMP_CHARGE = 0.5
var sand_in_bottom: float = 1.0:
	set(new_sand_in_bottom):
		sand_in_bottom = max(new_sand_in_bottom, 0)
		if sand_in_bottom >= total_sand:
			die()
	get():
		return sand_in_bottom
var total_sand: float = 6.0
var jump_charge = 0.0
var died = false
@export var jump_charge_curve: Curve

const MAX_SPEED = 150

func _ready() -> void:
	GameState.player = self

func _physics_process(delta: float):
	$Placeholder.text = str(round(sand_in_bottom / total_sand * 100)) + "%"
	if is_on_floor():
		velocity.x = 0
		if Input.is_action_pressed("jump"):
			jump_charge = move_toward(jump_charge, MAX_JUMP_CHARGE, delta)
		elif Input.is_action_just_released("jump"):
			velocity.y = MAX_JUMP * jump_charge_curve.sample(jump_charge/MAX_JUMP_CHARGE)
			sand_in_bottom = total_sand - sand_in_bottom
			jump_charge = 0.0
	else:
		var dir = Input.get_axis("left", "right")
		velocity.x = MAX_SPEED * dir
		velocity.y += GRAVITY * delta # add curve later
	move_and_slide()
	
	sand_in_bottom += delta

func damage(dmg: int) -> void:
	total_sand -= dmg
	sand_in_bottom = min(sand_in_bottom, total_sand)
	
func die() -> void:
	if not died:
		died = true
		print('i am become dead')
