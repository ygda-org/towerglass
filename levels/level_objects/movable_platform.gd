extends Node2D

@export var size: int = 5
@export var tile: PackedScene
var start_pos: Vector2

func _ready() -> void:
	var posx = 0
	start_pos = position
	for i in range(size):
		var addend = tile.instantiate()
		if addend.name == 'MovableTile':
			if i == 0:
				addend.get_node("AnimatedSprite2D").set_animation('left')
			elif i == size - 1:
				addend.get_node("AnimatedSprite2D").set_animation('right')
			else:
				addend.get_node("AnimatedSprite2D").set_animation('middle')
		addend.position = Vector2(posx, 0)
		posx += 16
		add_child(addend)

func _physics_process(delta: float) -> void:
	var i: int = 0
	for child in get_children():
		child.global_position = global_position + Vector2(i * 16, 0)
		i += 1
