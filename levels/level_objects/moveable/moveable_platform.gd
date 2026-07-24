@tool
extends Node2D

@export var size: int = 5:
	set(new_size):
		size = new_size
		for node in get_children():
			node.queue_free()
		_ready()
@export var tile: PackedScene:
	set(new_tile):
		tile = new_tile
		for node in get_children():
			node.queue_free()
		_ready()
@export var wait_until_player_touches_to_move: bool = false
var moving: bool = true
var crumbler: bool = false

signal touched_player

func _ready() -> void:
	moving = not wait_until_player_touches_to_move
	for i in range(size):
		var addend = tile.instantiate()
		if addend.name == 'MovableTile':
			if i == 0:
				addend.get_node("AnimatedSprite2D").set_animation('left')
			elif i == size - 1:
				addend.get_node("AnimatedSprite2D").set_animation('right')
			else:
				addend.get_node("AnimatedSprite2D").set_animation('middle')
		elif addend.name == "CrumblingTile":
			crumbler = true
			if i == 0:
				addend.side = "left"
			elif i == size - 1:
				addend.side = "right"
			else:
				addend.side = "middle"
		addend.rotation = rotation
		add_child(addend)

func _physics_process(delta: float) -> void:
	var i: int = 0
	for child in get_children():
		child.global_position = global_position + Vector2((i - size / 2.0) * 16, 0)
		i += 1
	if Engine.is_editor_hint():
		return
	if not moving and wait_until_player_touches_to_move:
		for child in get_children():
			if GameState.player.left_floor == child or GameState.player.left_floor == child:
				touched_player.emit()
				moving = true
	if crumbler:
		for child in get_children():
			if "CrumblingTile" in child.name and not child.crumbling and (GameState.player.left_floor == child or GameState.player.right_floor == child):
				for child2 in get_children():
					child2.crumble()
					child2.crumbling = true
