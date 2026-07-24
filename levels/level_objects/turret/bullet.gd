extends CharacterBody2D


const SPEED = 300.0

func _ready() -> void:
	velocity *= SPEED
func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider()==GameState.player:
			GameState.player.damage(5)
	if get_slide_collision_count() != 0:
		queue_free()
	
	move_and_slide()
