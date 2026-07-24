extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_body_entered(body: Node2D) -> void:
	if body == GameState.player:
		super_cool_exit_animation()
		SceneSwitcher.go_to_scene("res://ui/end_screen.tscn")


func super_cool_exit_animation():
	pass
