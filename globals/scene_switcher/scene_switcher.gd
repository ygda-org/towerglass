extends CanvasLayer

enum TYPE {
	FADE,
	CHECK,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.color.a = 0.0

func set_background_color(color : Color) -> void:
	$ColorRect.color = color
	$ColorRect.color.a = 0.0

func go_to_scene(target : String, type : TYPE = TYPE.FADE) -> void:
	starting_transition(type)
	await $Anim.animation_finished
	get_tree().change_scene_to_file(target)
	ending_transition(type)
	await $Anim.animation_finished

func starting_transition(type : TYPE):
	match type:
		TYPE.FADE:
			$ColorRect.color.a = 0.0
			$Anim.play("fade_in")
			await $Anim.animation_finished
		#TYPE.CHECK:
			#$ColorRect.color.a = 1.0
			#var tween : Tween = Tween.new()
			#tween.tween_property($ColorRect, "shader_parameter/start_percent", 1.0, 1.0)

func ending_transition(type : TYPE):
	match type:
		TYPE.FADE:
			$Anim.play("fade_out")
