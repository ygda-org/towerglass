extends Node
# this node to be added as a global named SFX

enum Labels {
	YGDASTING,
	BUTTONCLICK,
	BUTTONHOVER,
	DEATHSPILL,
	WALK,
	FLIP,
	FLIPSANDFALL,
	HOURGLASSFALL,
	TOWERCROSSWHOOSH,
	JUMPCHARGE,
	CLOCKS,
	GEARS,
	INDUSTRYAMBIENCE,
	BELL,
	BULLETHITWALL,
	BULLETSHOOT,
	TURRETTURN,
	ONANDOFF,
	SANDFALLING,
	BOILERAMBIENCE,
	PLAYERHIT,
	SQUEAK,
	PLATFORMCRUMBLE,
	
}

const print_sounds: bool = false

@export var label_to_setting: Dictionary[Labels, SfxSettings]

## play a sound effect, as defined by label. Intended should be SFX.play(SFX.Labels.NAME)
func play(label: Labels):
	if print_sounds:
		print("playing: ", Labels.keys()[label])
	if has_node(Labels.keys()[label]):
		return
	var audio = AudioStreamPlayer.new()
	var setting = label_to_setting[label]
	audio.bus = setting.bus
	audio.stream = setting.stream
	audio.name = Labels.keys()[label] + str(hash(audio))
	audio.volume_db = setting.volume + randf_range(-1,1) * setting.volume_variance
	audio.pitch_scale = setting.pitch + randf_range(-1,1) * setting.pitch_variance
	add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.playing = true
	if setting.min_delay == 0:
		return
	var timer : Timer = Timer.new()
	timer.name = Labels.keys()[label]
	timer.wait_time = setting.min_delay
	timer.autostart = true
	timer.timeout.connect(timer.queue_free)
	add_child(timer)

## remove all playing audio nodes
func force_clear_audios():
	for node in get_children():
		node.queue_free()

## remove all playing audio of a specific type
func clear_audio(label : Labels):
	for node in get_children():
		if Labels.keys()[label] in node.name:
			node.queue_free()
