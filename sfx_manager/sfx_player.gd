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
	LEVELSTART,
	LEVELTRANSITION,
	STEAM,
	STEAMALT,
	BOUNCEOFFMOUSE,
	BITE,
	WINDUPSPARKLE,
	BURNER,
	SAW,
	STICKYPLATFORMHIT,
	STICKYPLATFORMWALK,
}

const print_sounds: bool = true

@export var label_to_setting: Dictionary[Labels, SfxSettings]

## play a sound effect, as defined by label. Intended should be SFX.play(SFX.Labels.NAME)
func play(label: Labels, optional_volume: float = 0.0):
	if has_node(Labels.keys()[label]):
		return
	var audio = AudioStreamPlayer.new()
	var setting = label_to_setting[label]
	audio.bus = setting.bus
	audio.stream = setting.stream
	audio.name = Labels.keys()[label] + str(hash(audio))
	audio.volume_db = setting.volume + randf_range(-1,1) * setting.volume_variance + optional_volume
	audio.pitch_scale = setting.pitch + randf_range(-1,1) * setting.pitch_variance
	add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.playing = true
	if print_sounds:
		print("playing: ", Labels.keys()[label])
	if setting.min_delay == 0:
		return
	var timer : Timer = Timer.new()
	timer.name = Labels.keys()[label]
	timer.wait_time = setting.min_delay
	timer.autostart = true
	timer.timeout.connect(timer.queue_free)
	add_child(timer)
	# hardcode time
	if label == Labels.SANDFALLING:
		rec_sand_fall_vol = audio.volume_db
		sand_fall = audio

## remove all playing audio nodes
func force_clear_audios():
	for node in get_children():
		node.queue_free()

## Pause all audio nodes
func force_pause_audios():
	for node in get_children():
		if node is AudioStreamPlayer:
			node.stream_paused = true

## Play all audio nodes
func force_play_audios():
	for node in get_children():
		if node is AudioStreamPlayer:
			node.stream_paused = false
			
## Play all audio nodes of a specific type
func play_audios(label: Labels):
	for node in get_children():
		if Labels.keys()[label] in node.name and node is AudioStreamPlayer:
			node.stream_paused = false

## remove all playing audio of a specific type
func clear_audio(label : Labels):
	for node in get_children():
		if Labels.keys()[label] in node.name:
			node.queue_free()


# hardcoded stuff
var sand_fall = null
var rec_sand_fall_vol

func _process(_delta):
	if sand_fall and GameState.player:
		var player = GameState.player
		sand_fall.volume_db = rec_sand_fall_vol + 20*(player.sand_in_bottom/player.total_sand)
