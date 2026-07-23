extends Node2D

const CRUMBLING_TILE = preload("uid://bn4m4aljk32wv")

@export var tiles: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "CrumblingPlatform" + str(hash(self))
	var posx: int = 0
	for i in range(tiles):
		var tile = CRUMBLING_TILE.instantiate()
		tile.position.x += posx
		posx += 80
		tile.crumble_platform.connect(crumble)
		add_child(tile)

func crumble() -> void:
	for child in get_children():
		child.crumble()
