extends CharacterBody2D

var velo: int = 50
var dir = 1
var collider
var biting = false
@onready var spawn:= Vector2 (global_position.x, global_position.y)

## set to -1 or 1 to freeze rat. number is direction
@export var frozen: int = 0

var player_visible = false

func _ready() -> void:
	GameState.player.died.connect(respawn)
	if frozen:
		dir = frozen
		$Area2D.scale.x = dir
		$AnimatedSprite2D.play("walk")


func _physics_process(delta: float) -> void:
	if not frozen:
		move_and_slide()
	if biting:
		return
	
	if player_visible == true:
		SFX.play(SFX.Labels.SQUEAK)
		
	if not frozen:
		if not is_on_floor():
			$AnimatedSprite2D.play("air")
			velocity.y += 250 * delta
		else:
			$AnimatedSprite2D.play("walk")
	
	if not frozen:
		if is_on_wall() or $Area2D/RayCast2D.get_collider() == null:
			dir *= -1
			$Area2D.scale.x *= -1
		
	
	if dir == 1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	velocity.x = velo * dir
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body != GameState.player:
		return
	
	biting = true
	velo = 0
	if GameState.player.velocity.y > 200:
		$AnimatedSprite2D.play("youch")
		GameState.player.velocity.y = -250
	else:
		$AnimatedSprite2D.play("bite")
		SFX.play(SFX.Labels.BITE)
		SFX.play(SFX.Labels.PLAYERHIT)
		await $AnimatedSprite2D.animation_finished
	if $Area2D.overlaps_body(body):
		SFX.play(SFX.Labels.BOUNCEOFFMOUSE)
		GameState.player.velocity.y = -250
		GameState.player.flip()
		await get_tree().create_timer(0.05).timeout
		GameState.player.velocity.x = (200 * dir)
		GameState.player_jumped.emit()
	biting = false
	velo = 50


func _on_visible_on_screen_notifier_2d_screen_entered():
	player_visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	player_visible = false


func respawn():
	global_position = spawn
