extends StaticBody2D

enum SIDE{
	LEFT,
	MID,
	RIGHT,
}

# if you change this node"s name it will no longer function in movable platforms
@export var side: String = "middle"

var crumbling : bool = false
var queue_reenable: bool = false

func _ready() -> void:
	side_anim("default")
	name = "CrumblingTile" + str(hash(self))

func crumble():
	SFX.play(SFX.Labels.PLATFORMCRUMBLE)
	side_anim("crumbling")
	$CrumbleTimer.start()
	await $CrumbleTimer.timeout
	$CollisionShape2D.disabled = true
	$RatCollision/CollisionShape2D2.disabled = true
	$RegenerateTimer.start()
	await $RegenerateTimer.timeout
	side_anim("regenerate")
	await $AnimatedSprite2D.animation_finished
	queue_reenable = true
	crumbling = false

func _physics_process(delta: float) -> void:
	if not crumbling and (GameState.player.left_floor == self or GameState.player.right_floor == self):
		crumbling = true
		crumble()
	if queue_reenable and not $Area2D.has_overlapping_bodies():
		$CollisionShape2D.disabled = false
		$RatCollision/CollisionShape2D2.disabled = false
		queue_reenable = false

func side_anim(anim_name: String) -> void:
	if side == "":
		print("huh")
	$AnimatedSprite2D.play(side + "_" + anim_name)
