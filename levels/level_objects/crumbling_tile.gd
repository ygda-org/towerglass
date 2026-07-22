extends StaticBody2D

signal crumble_platform
# ANIMATED SPRITE SCALE IS 0.125 BECAUSE PLACEHOLDER IS 128x128. REMEMBER TO CHANGE

func _on_crumble_area_body_entered(body: Node2D) -> void:
	crumble_platform.emit()

func crumble():
	$AnimatedSprite2D.play('crumbling')

func _physics_process(delta: float) -> void:
	if $CollisionShape2D.disabled and $AnimatedSprite2D.animation == 'default' and not $CollisionArea.has_overlapping_bodies():
		$CollisionShape2D.disabled = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == 'crumbling':
		visible = false
		$CollisionShape2D.disabled = true
		$Timer.start()
	elif $AnimatedSprite2D.animation == 'regenerate':
		$AnimatedSprite2D.play('default')


func _on_timer_timeout() -> void:
	visible = true
	$AnimatedSprite2D.play('regenerate')
