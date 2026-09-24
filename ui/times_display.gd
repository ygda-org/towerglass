extends Control

func _process(_delta):
	var focused = get_viewport().gui_get_focus_owner()
	if focused is SelectButton:
		var ret = "Best times:\n"
		var index = focused.number-1
		for i in range(Leaderboard.names[index].size()):
			ret += "{0}: {1}\n".format([Leaderboard.names[index][i], str(snappedf(Leaderboard.leaderboards[index][i], 0.01))])
		$Panel/Label.text = ret
