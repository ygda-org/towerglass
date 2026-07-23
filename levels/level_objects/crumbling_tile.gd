extends StaticBody2D

enum SIDE{
	LEFT,
	MID,
	RIGHT,
}

# if you change this node"s name it will no longer function in movable platforms
@export var side: String = "middle"

var crumbling : bool = false

func _ready() -> void:
	side_anim("default")
	name = "CrumblingTile" + str(hash(self))

func crumble():
	side_anim("crumbling")
	await $AnimatedSprite2D.animation_finished
	$CollisionShape2D.disabled = true
	$RegenerateTimer.start()
	

func _physics_process(delta: float) -> void:
	if not crumbling and (GameState.player.left_floor == self or GameState.player.right_floor == self):
		crumbling = true
		crumble()

func _on_timer_timeout() -> void:
	side_anim("regenerate")
	await $AnimatedSprite2D.animation_finished
	$CollisionShape2D.disabled = false
	crumbling = false

func side_anim(anim_name: String) -> void:
	$AnimatedSprite2D.play(side + "_" + anim_name)
