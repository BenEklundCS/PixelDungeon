enum direction {
	RIGHT, LEFT, UP, DOWN
}

enum damage_type {
	MAGIC, PHYSICAL
}

static func get_random_position_in_range(position: Vector2, move_range : int) -> Vector2:
	"""
	Returns a position that is close to the given position, but randomized in location.
	"""
	var position_x_modifier = (randf() * move_range) * (-1 if randf() > 0.5 else 1)
	var position_y_modifier = (randf() * move_range) * (-1 if randf() > 0.5 else 1)
	return Vector2(position.x + position_x_modifier, position.y + position_y_modifier)

