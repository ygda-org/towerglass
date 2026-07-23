extends CharacterBody2D


const SPEED = 300.0

func _ready() -> void:
	velocity *= SPEED

func _physics_process(delta: float) -> void:
	
	if get_slide_collision_count() != 0:
		queue_free()
	
	move_and_slide()
