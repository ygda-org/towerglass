extends Node2D

@export var sprite: Node #Put all the sprites in this node (Example: u want a row of spikes for one attack node and not an individual attack node for each spike)
#@export var dmg: int = 9999
#uncomment previous line if we decide to make spikes and such not instakill

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			child.body_entered.connect(on_hit)

func on_hit(character: Node2D) -> void:
	#if character.has_method("damage"):
	#	character.damage(dmg)
	#uncomment previous two lines if we decide to make spikes and such not instakill
	#subsequently, comment out the next two lines
	if character.has_method("die"):
		character.die()
