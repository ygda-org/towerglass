extends Node
# this node to be added as a global named SFX

enum Labels {
	YGDASTING,
	
}

@export var label_to_setting: Dictionary[Labels, SfxSettings]

## play a sound effect, as defined by label. Intended should be SFX.play(SFX.Labels.NAME)
func play(label: Labels):
	if has_node(Labels.keys()[label]):
		return
	var audio = AudioStreamPlayer.new()
	audio.bus = "SFX"
	var setting = label_to_setting[label]
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
