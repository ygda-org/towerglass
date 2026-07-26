extends CharacterBody2D


const SPEED = 300.0

var player_visible: bool = false

var played_ding: bool = false

var time

func _ready() -> void:
	velocity *= SPEED
	$Timer.wait_time = time
	$Timer.start()

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider()==GameState.player:
			SFX.play(SFX.Labels.PLAYERHIT)
			GameState.player.damage(1.5)
	if get_slide_collision_count() != 0:
		if player_visible and not played_ding:
			SFX.play(SFX.Labels.BULLETHITWALL)
			played_ding = true
			print(position)
		queue_free()
	
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered():
	player_visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	player_visible = false


func _on_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.7)
	tween.tween_callback(queue_free)
