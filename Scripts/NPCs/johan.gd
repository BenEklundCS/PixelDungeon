extends "res://Scripts/Classes/npc.gd"

@export var move_range: int = 300
var target_position: Vector2
var destination_reached: bool = true

func _ready() -> void:
	print("Hallo! Ich Heiße Johan.")

func _process(delta: float) -> void:
	# If destination is reached, pick a new target position
	if destination_reached:
		target_position = Utils.get_random_position_in_range(position, move_range)

		# Ensure the target is far enough
		if position.distance_to(target_position) < 10:
			return

		destination_reached = false

	# Move towards the target position
	if target_position:
		move_towards(target_position, delta, false)

		# Check if Johan has reached the target position
		if position.distance_to(target_position) < 10:  # Adjust threshold as needed
			destination_reached = true