extends Area2D
@onready var moving_stuff = $"../.."
@onready var move_speed = moving_stuff.curve.get_baked_length() / moving_stuff.time * 2
func _physics_process(delta: float) -> void:
	GameState.player.position.x += move_speed * delta



func _on_body_entered(body: Node2D) -> void:
	moving_stuff.moving = true
