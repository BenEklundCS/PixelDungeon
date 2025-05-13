extends CharacterBody2D
# load game Utilities
var Utils = preload("res://Scripts/utils.gd")
const Combatant = preload("res://Scripts/Classes/combatant.gd")

var initial_position: Vector2
var direction: Vector2 = Vector2.ZERO
@export var speed: float = 750

func _ready() -> void:
	# save the initial position on-load
	initial_position = position
	$Animation.play()
	pass

func _process(delta: float) -> void:
	handle_movement(delta)

func handle_movement(_delta: float):
	# Move the flame 
	velocity = direction * speed
	move_and_slide()

func _on_animation_animation_finished() -> void:
	queue_free() # delete after animation finishes
