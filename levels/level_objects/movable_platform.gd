extends Node2D

@export var size: int = 5
var start_pos: Vector2
const MOVABLE_TILE = preload("uid://cp7kql7qpqvxm")

func _ready() -> void:
	var posx = 0
	start_pos = position
	for i in range(size):
		var tile = MOVABLE_TILE.instantiate()
		if i == 0:
			tile.get_node("AnimatedSprite2D").set_animation('left')
		elif i == size - 1:
			tile.get_node("AnimatedSprite2D").set_animation('right')
		else:
			tile.get_node("AnimatedSprite2D").set_animation('middle')
		tile.position = Vector2(posx, 0)
		posx += 16
		add_child(tile)

func _physics_process(delta: float) -> void:
	var i: int = 0
	for child in get_children():
		child.global_position = global_position + Vector2(i * 16, 0)
		i += 1
