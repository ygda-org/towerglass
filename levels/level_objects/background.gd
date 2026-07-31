extends Node2D

@onready var camera : Camera2D

@onready var b1 = $Offset/Parallax2D/Background
@onready var b2 = $Offset/Parallax2D2/Gears
@onready var b3 = $Offset/Parallax2D4/BigPipes
@onready var b4 = $Offset/Parallax2D3/SmallPipes

var speed_1 : float = 0.05
var speed_2 : float = 0.2
var speed_3 : float = 0.15
var speed_4 : float = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Offset/Parallax2D2/Gear1.rotation += speed_1 * delta
	$Offset/Parallax2D2/Gear2.rotation += speed_2 * delta
	$Offset/Parallax2D2/Gear3.rotation -= speed_2 * delta
	$Offset/Parallax2D2/Gear4.rotation += speed_3 * delta
	$Offset/Parallax2D2/Gear5.rotation -= speed_3 * delta
	$Offset/Parallax2D2/Gear6.rotation -= speed_4 * delta
