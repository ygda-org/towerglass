extends StaticBody2D

enum SIDE{
	LEFT,
	MID,
	RIGHT,
}

# if you change this node's name it will no longer function in movable platforms
@export var side: String

func _ready() -> void:
	side_anim("default")
	name = "CrumblingTile" + str(hash(self))

func crumble():
	if "default" in $AnimatedSprite2D.animation:
		side_anim('crumbling')

func _physics_process(delta: float) -> void:
	if GameState.player.left_floor == self or GameState.player.right_floor == self:
		$CollisionShape2D.disabled = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if 'crumbling' in $AnimatedSprite2D.animation:
		visible = false
		$CollisionShape2D.disabled = true
		$Timer.start()
	elif 'regenerate' in $AnimatedSprite2D.animation:
		side_anim('default')

func _on_timer_timeout() -> void:
	visible = true
	side_anim('regenerate')

func side_anim(anim_name: String) -> void:
	$AnimatedSprite2D.play(side + "_" + anim_name)
