extends "res://Scripts/Classes/combatant.gd"
const Enemy = preload("res://Scripts/Classes/enemy.gd")

var screen_size: Vector2 # game window size
var attacking: bool = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	speed = 650
	
func handle_animation() -> void:
	# change animation
	if (velocity == Vector2.ZERO):
		$Animation.animation = "idle"
	else:
		$Animation.animation = "run"
	$Animation.play()
	flip($Animation)

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
	super.swing(2)
	var bodies: Array[Node2D] = check_for_hits()
	if bodies:
		for body in bodies:
			if body is Enemy:
				body.hurt(base_damage, Utils.damage_type.PHYSICAL)

func _process(delta: float) -> void:
	move(delta)
	if swinging:
		$HurtBox.monitoring = true
	else:
		$HurtBox.monitoring = false

	if Input.is_action_pressed("attack"):
		attack()
	super._process(delta)

func _on_hurt_box_body_entered(body:Node2D) -> void:
	pass
