extends CharacterBody2D
# load game Utilities
var Utils = preload("res://Scripts/utils.gd")
const Combatant = preload("res://Scripts/Classes/combatant.gd")
const Enemy = preload("res://Scripts/Classes/enemy.gd")

var initial_position: Vector2
var direction: Vector2 = Vector2.ZERO
@export var speed: float = 750
@export var strike_damage: int = 25

func _ready() -> void:
	# save the initial position on-load
	initial_position = position
	$Animation.play()
	# play sfx on spawn
	$Audio.play()
	pass

func _process(delta: float) -> void:
	handle_movement(delta)

func handle_movement(_delta: float):
	# Move the flame 
	velocity = direction * speed
	move_and_slide()

func _on_animation_animation_finished() -> void:
	queue_free() # delete after animation finishes
	
func check_for_hits() -> Array[Node2D]:
	var bodies = $HurtBox.get_overlapping_bodies()
	return bodies

func _on_hurt_box_body_entered(_body: Node2D) -> void:
	var bodies: Array[Node2D] = check_for_hits()
	for b in bodies:
		if b is Enemy:
			b.hurt(strike_damage, Utils.damage_type.PHYSICAL)
