extends Node2D

@onready var camera : Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if camera == null and GameState.player != null:
		#camera = GameState.player.find_child("Camera2D")
	#global_position.y = camera.global_position.y
	pass
