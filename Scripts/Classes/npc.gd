extends CharacterBody2D

# load game Utilities
var Utils = preload("res://Scripts/utils.gd")

###
#
# NPC is the base class for game characters. It implements movement, and animations.
###

# current direction the character is facing
var facing: int = Utils.direction.RIGHT # Default direction
# current speed of the character factored into their movement
@export var speed: int = 200 # Default speed


# Base movement functionality for moving towards a position
func move_towards(target_position: Vector2, delta: float, up_animations: bool) -> void:
	velocity = Vector2.ZERO

	var y_distance_greater_than_x = abs(position.x - target_position.x) < abs(position.y - target_position.y)
	
	if target_position.x > position.x:
		velocity.x += 1
		facing = Utils.direction.RIGHT
	if target_position.x < position.x:
		velocity.x -= 1
		facing = Utils.direction.LEFT
	if target_position.y > position.y:
		if up_animations && y_distance_greater_than_x:
			facing = Utils.direction.DOWN
		velocity.y += 1
	if target_position.y < position.y:
		if up_animations && y_distance_greater_than_x:
			facing = Utils.direction.UP
		velocity.y -= 1

	velocity = velocity.normalized() * speed

	handle_animation()

	move_and_collide(velocity * delta)


# Override this in child classes
func handle_animation() -> void:
	pass

# Base sprite flipping functionality
func flip(sprite) -> void:
	if facing == Utils.direction.LEFT:
		sprite.get_parent().rotation = PI
		sprite.get_parent().scale.y = -3
	elif facing == Utils.direction.RIGHT:
		sprite.get_parent().rotation = 0
		sprite.get_parent().scale.y = 3
