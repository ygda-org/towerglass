extends Node2D

@onready var camera : Camera2D

@onready var b1 = $Offset/Parallax2D/Background
@onready var b2 = $Offset/Parallax2D2/Gears
@onready var b3 = $Offset/Parallax2D4/BigPipes
@onready var b4 = $Offset/Parallax2D3/SmallPipes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if camera == null and GameState.player != null:
		#camera = GameState.player.find_child("Camera2D")
	#global_position.y = camera.global_position.y
	pass
