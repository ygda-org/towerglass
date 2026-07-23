extends CharacterBody2D


var follow_speed_mult = 3

func _physics_process(_delta):
	velocity = follow_speed_mult * (get_parent().global_position - global_position)
	move_and_slide()
