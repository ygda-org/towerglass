extends StaticBody2D

@export var initial_state: bool
@onready var current_state = initial_state

var queue_to_flip = false

func _ready():
	GameState.player_jumped.connect(flip)
	current_state = current_state == false
	name = "OnOffBlock" + str(hash(self))
	flip()

func _process(_delta):
	if queue_to_flip:
		if current_state and GameState.player and GameState.player in $Area2D.get_overlapping_bodies():
			return
		queue_to_flip = false
		$CollisionShape2D.disabled = not current_state
		if current_state == true:
			$AnimatedSprite2D.play('on')
		else:
			$AnimatedSprite2D.play('off')
func flip():
	current_state = not current_state
	queue_to_flip = true
