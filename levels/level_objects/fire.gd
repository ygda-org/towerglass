extends StaticBody2D

var player_visible: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.pause()
	await get_tree().create_timer(randf()).timeout
	$AnimatedSprite2D.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_visible == true:
		SFX.play(SFX.Labels.BURNER)

func _on_visible_on_screen_notifier_2d_screen_entered():
	player_visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	player_visible = false
