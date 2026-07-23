extends StaticBody2D
#crumble platform functionality removed; no longer tileable
#signal crumble_platform

func _on_crumble_area_body_entered(body: Node2D) -> void:
	#crumble_platform.emit()
	crumble()

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
