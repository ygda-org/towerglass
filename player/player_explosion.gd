extends Node2D

signal exploded

var bottom_name: String = "yellow"

func _ready():
	$Sand.play("default_" + bottom_name)
	$Sand.play("default_" + bottom_name)
	$Anim.play("default")
	await get_tree().create_timer(0.4).timeout
	SFX.play(SFX.Labels.DEATHSPILL)
	await get_tree().create_timer(0.4).timeout
	$Anim.visible = false
	$ExplosionPieces.visible = true
	$Sprite2D3.visible = true
	explode()

func explode():
	$Sand.play("spill_" + bottom_name)
	var tweeeeeen = get_tree().create_tween()
	tweeeeeen.tween_property($Sand, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	for node in $ExplosionPieces.get_children():
		var tween = get_tree().create_tween()
		if "Head" in node.name:
			if "2" in node.name:
				tween.tween_property(node, "position", node.position + Vector2(50,0).rotated(-PI/3), 1.0)
			else:
				tween.tween_property(node, "position", node.position + Vector2(50,0).rotated(-2*PI/3), 1.0)
		else:
			tween.tween_property(node, "position", node.position + Vector2(100,0).rotated(randf_range(0,TAU)), 1.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(node, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0)
	$Timer.start()


func _on_timer_timeout():
	exploded.emit()
