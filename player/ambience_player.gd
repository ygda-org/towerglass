extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SFX.play(SFX.Labels.INDUSTRYAMBIENCE)
	rand_wait(30,60, SFX.Labels.CLOCKS)
	SFX.play(SFX.Labels.GEARS)
	SFX.play(SFX.Labels.BOILERAMBIENCE)
	#SFX.play(SFX.Labels.SANDFALLING)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func rand_wait(minimum_seconds, maximum_seconds, audio):
	SFX.play(audio)
	var wait = randi_range(minimum_seconds, maximum_seconds)
	await get_tree().create_timer(wait).timeout
	rand_wait(minimum_seconds, maximum_seconds, audio)
