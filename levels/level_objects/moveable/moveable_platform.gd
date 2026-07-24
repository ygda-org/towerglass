extends AnimatableBody2D

@export var size: int = 5#:
	#set(new_size):
	#	size = new_size
	#	for node in get_children():
	#		node.queue_free()
	#	_ready()
@export var tile: PackedScene
@export var wait_until_player_touches_to_move: bool = false
var moving: bool = true
var crumbler: bool = false
@export var hitboxes: bool = false
var tile_name: String

signal touched_player

func _ready() -> void:
	for node in get_children():
		node.queue_free()
	moving = not wait_until_player_touches_to_move
	for i in range(size):
		var addend = tile.instantiate()
		tile_name = addend.name
		if tile_name == 'MoveableTile':
			if i == 0:
				addend.get_node("AnimatedSprite2D").set_animation('left')
			elif i == size - 1:
				addend.get_node("AnimatedSprite2D").set_animation('right')
			else:
				addend.get_node("AnimatedSprite2D").set_animation('middle')
		elif tile_name == "CrumblingTile":
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
		if tile_name == "MoveableTile":
			if GameState.player.left_floor == self or GameState.player.right_floor == self:
				touched_player.emit()
				moving = true
		else:
			for child in get_children():
				if GameState.player.left_floor == child or GameState.player.right_floor == child:
					touched_player.emit()
					moving = true
				else:
					for child2 in child.get_children():
						if GameState.player.left_floor == child2 or GameState.player.right_floor == child2:
							touched_player.emit()
							moving = true
	if tile_name == "CrumblingTile":
		for child in get_children():
			if not child.crumbling and (GameState.player.left_floor == child or GameState.player.right_floor == child):
				for child2 in get_children():
					child2.crumble()
					child2.crumbling = true
