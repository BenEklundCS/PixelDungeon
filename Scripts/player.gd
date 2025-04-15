extends "res://Scripts/Classes/combatant.gd"

var offset: int = 16
var screen_size: Vector2 # game window size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	speed = 650
	
func handle_animation() -> void:
	# change animation
	if (velocity == Vector2.ZERO):
		$KnightAnimation.animation = "idle"
	else:
		$KnightAnimation.animation = "run"

	$KnightAnimation.play()
	
	flip($KnightAnimation)

func move(delta: float) -> void:
	# find movement Utils.direction to add to velocity
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		facing = Utils.direction.RIGHT
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		facing = Utils.direction.LEFT
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed

	handle_animation()

	# move the player's position
	move_and_collide(velocity * delta)

func attack() -> void:
	# attack logic
	pass

func _process(delta: float) -> void:
	move(delta)

	if Input.is_action_pressed("attack"):
		attack()

func _on_animated_sprite_2d_animation_changed() -> void:
	if ($KnightAnimation.animation == "idle"):
		$KnightAnimation.position.y += offset
	elif ($KnightAnimation.animation == "run"):
		$KnightAnimation.position.y -= offset
