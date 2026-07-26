extends StaticBody2D

var player_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_visible == true:
		pass
		SFX.play(SFX.Labels.SAW)

func _on_visible_on_screen_notifier_2d_screen_entered():
	player_visible = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	player_visible = false
