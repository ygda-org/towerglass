extends CharacterBody2D

var velo: int = 50
var dir = 1
var collider
var biting = false

var player_visible = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	if player_visible == true:
		SFX.play(SFX.Labels.SQUEAK)
		
	if biting:
		return
	
	if not is_on_floor():
		$AnimatedSprite2D.play("air")
		velocity.y += 20 * delta
	else:
		$AnimatedSprite2D.play("walk")
	
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
	if body != GameState.player:
		return
	
	biting = true
	if GameState.player.velocity.y > 200:
		$AnimatedSprite2D.play("youch")
		GameState.player.velocity.y -= 250
	else:
		$AnimatedSprite2D.play("bite")
		SFX.play(SFX.Labels.PLAYERHIT)
		await $AnimatedSprite2D.animation_finished
	if $Area2D.overlaps_body(body):
		GameState.player.velocity.y -= 250
		GameState.player.flip()
	await get_tree().create_timer(0.05).timeout
	GameState.player.velocity.x += (200 * dir)
	biting = false


func _on_visible_on_screen_notifier_2d_screen_entered():
	player_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	player_visible = false
