extends Control

const BUCKET_AMOUNT = 10
@onready var GRAPH_WIDTH = $Panel.size.x
@onready var GRAPH_HEIGHT = $Panel.size.y

var bars: Array[ColorRect] = []

const BAR_COLOR = Color(0.194, 0.695, 0.763, 1.0)

func _ready():
	visible = true
	_draw_self()
	update()

func _process(_delta):
	update()

func update():
	var focused = get_viewport().gui_get_focus_owner()
	if focused is not SelectButton:
		visible = false
		return
	visible = true
	var lindex = focused.number-1
	var times = Leaderboard.leaderboards[lindex].duplicate()
	## index 0 is slowest times, 9 is fastest
	var buckets = []
	for i in range(BUCKET_AMOUNT):
		buckets.append([])
	var max_time = times.max()+0.01
	var min_time = times.min()-0.01
	var bucket_size = (max_time-min_time)/BUCKET_AMOUNT
	for i in range(BUCKET_AMOUNT):
		for j in range(times.size()):
			if times[j] >= max_time - (i+1)*bucket_size:
				buckets[i].append(times[j])
				times[j] = -1
	var bucket_sizes: Array[int] = []
	for bucket in buckets:
		bucket_sizes.append(bucket.size())
	_set_bars(bucket_sizes)

func _draw_self():
	bars = []
	for i in range(BUCKET_AMOUNT):
		var bar: ColorRect = ColorRect.new()
		bar.color = BAR_COLOR
		bar.size_flags_vertical = Control.SIZE_SHRINK_END
		bars.append(bar)
		$Panel.size.x = GRAPH_WIDTH
		$Panel.size.y = GRAPH_HEIGHT
		bar.custom_minimum_size.x = GRAPH_WIDTH/BUCKET_AMOUNT
		bar.custom_minimum_size.y = 0
		$Panel/HBoxContainer.add_child(bar)

func _set_bars(bucket_sizes):
	var max_height = bucket_sizes.max()
	for i in range(BUCKET_AMOUNT):
		var bar_height = GRAPH_HEIGHT * (float(bucket_sizes[i])/float(max_height))
		bars[i].custom_minimum_size.y = bar_height
		bars[i].size.y = bar_height
