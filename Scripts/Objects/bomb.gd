extends Node2D
# load game Utilities
var Utils = preload("res://Scripts/utils.gd")

@export var fuse: float = 1.0 # time until bomb explodes after spawning
@export var bomb_damage: int = 100
var exploding: bool = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	# fuse handling, explode after the fuse runs out
	if fuse <= 0 && !exploding:
		explode()
	else:
		fuse -= delta

func check_for_hits() -> Array[Node2D]:
	var bodies = $HurtBox.get_overlapping_bodies()
	return bodies

func explode():
	exploding = true
	$Animation.animation = "explode"
	$Animation.play()
	$Audio.play()

	var bodies: Array[Node2D] = check_for_hits()
	for body in bodies:
		body.hurt(bomb_damage, Utils.damage_type.PHYSICAL)

func _on_animation_animation_finished() -> void:
	if $Animation.animation == "explode":
		queue_free()
