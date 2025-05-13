extends CharacterBody2D
# load game Utilities
var Utils = preload("res://Scripts/utils.gd")
const Combatant = preload("res://Scripts/Classes/combatant.gd")

@export var fuse: float = 3.0 # time until bomb explodes after spawning
@export var bomb_damage: int = 100
@export var gravity: float = 900
var initial_position: Vector2
var exploding: bool = false

func _ready() -> void:
	# save the initial position on-load
	initial_position = position
	pass

func handle_fuse(delta: float):
	# fuse handling, explode after the fuse runs out
	if fuse <= 0 && !exploding:
		explode()
	else:
		fuse -= delta

func handle_movement(delta: float):
	# Apply gravity to the velocity
	velocity.y += gravity * delta

	# Move the bomb and update its position
	move_and_slide()

	# Stop the bomb when it "lands" (reaches or exceeds its initial y position)
	if position.y >= initial_position.y:
		velocity = Vector2.ZERO
		position.y = initial_position.y  # Snap to the initial position to avoid overshooting

func _process(delta: float) -> void:
	handle_fuse(delta)
	handle_movement(delta)

func check_for_hits() -> Array[Node2D]:
	var bodies = $HurtBox.get_overlapping_bodies()
	return bodies

func explode():
	exploding = true
	scale *= 5
	velocity = Vector2.ZERO
	$Animation.animation = "explode"
	$Animation.play()
	$Audio.play()

	var bodies: Array[Node2D] = check_for_hits()
	for body in bodies:
		if body is Combatant:
			body.hurt(bomb_damage, Utils.damage_type.PHYSICAL)

func _on_animation_animation_finished() -> void:
	if $Animation.animation == "explode":
		queue_free()
