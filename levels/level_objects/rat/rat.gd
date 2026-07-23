extends CharacterBody2D

var velo: int = 50
var dir = 1
var collider
var biting = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if biting:
		return
	
	if is_on_wall():
		dir *= -1
		$Area2D.scale.x *= -1
	
	if dir == 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	velocity.x = velo * dir
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == GameState.player:
		biting = true
		$AnimatedSprite2D.play("bite")
		await $AnimatedSprite2D.animation_finished
		if $Area2D.overlaps_body(body):
			GameState.player.velocity.y = -200
		$Timer.start()
		await $Timer.timeout
		biting = false
