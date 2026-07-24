extends Area2D

# THIS MUST BE UNDER THE PLAYER IN THE SCENE TREE
func _ready() -> void:
	if len(get_children()) != 1 or not get_children()[0] is CollisionShape2D or not get_children()[0].shape is RectangleShape2D:
		print('level bounds needs exactly one collision shape 2d rectangle child')
		return
	var child = get_children()[0]
	var bound = child.shape
	GameState.player.get_node("Camera2D").limit_left = child.global_position.x - bound.size.x / 2
	GameState.player.get_node("Camera2D").limit_right = child.global_position.x + bound.size.x / 2
	GameState.player.get_node("Camera2D").limit_top = child.global_position.y - bound.size.y / 2
	GameState.player.get_node("Camera2D").limit_bottom = child.global_position.y + bound.size.y / 2
func _on_body_exited(body: Node2D) -> void:
	GameState.player.die()
