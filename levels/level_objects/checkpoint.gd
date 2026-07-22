extends Node

var activated: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activated = false
	GameState.last_location = GameState.player.global_position

func activate_checkpoint():
	activated = true
	$AnimationPlayer.play("activation")
	GameState.last_location = $RespawnPoint.global_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body == GameState.player and not activated:
		activate_checkpoint()
