extends "res://Scripts/Classes/enemy.gd"
const Player = preload("res://Scripts//player.gd")

var player: CharacterBody2D = null
var target_position: Vector2 = Vector2(0, 0)
var destination_reached: bool = false
var idle_timer: float = 0.0
var idle_duration: float = 3.0


@export var swing_cooldown: float = 2.0
var _cooldown: float = swing_cooldown
@export var move_range = 300


func _ready() -> void:
	$Animation.play()
	target_position = Utils.get_random_position_in_range(position, move_range)

func _process(delta : float) -> void:
	move(delta)
	attack(delta)

	super._process(delta)

# attack the player if the cooldown has expired, and if they're close enough
func attack(delta) -> void:
	# handle cooldown timer

	# if the cooldown is above 0, subtract delta from it to move it down to 0
	if _cooldown > 0.0:
		_cooldown -= delta

	# check if the player is close enough to swing
	if is_close():
		# if the cooldown has expired swing
		if _cooldown <= 0.0:
			super.swing(power)
			# attack objects in front
			var bodies: Array[Node2D] = check_for_hits()
			if bodies:
				for body in bodies:
					if body is Player:
						body.hurt(base_damage, Utils.damage_type.PHYSICAL)
			_cooldown = swing_cooldown

func move(delta: float) -> void:
	if is_close():
		$Animation.animation = "idle_base"
		destination_reached = true
		return
	# Check if we've reached our current destination
	if target_position && position.distance_to(target_position) < 10:
		destination_reached = true
		target_position = Vector2(0, 0)
		idle_timer = idle_duration
	
	# Count down idle timer only when we've reached a destination
	if destination_reached && idle_timer > 0:
		idle_timer -= delta
		$Animation.animation = "idle_base"
		$Animation.play()
	
	# Determine target based on circumstances
	if player && in_range():
		# Chase player when in range
		destination_reached = false
		target_position = player.position
	elif player && destination_reached && idle_timer <= 0:
		# Generate new random position when idle timer expired
		destination_reached = false
		target_position = Utils.get_random_position_in_range(position, move_range)
	
	# Move if we have a target
	if target_position:
		move_towards(target_position, delta, false)

# Override the base NPC animation function
func handle_animation() -> void:
	# change animation
	if (velocity == Vector2.ZERO):
		$Animation.animation = "idle_base"
	else:
		$Animation.animation = "run_base"
	$Animation.play()
	flip($Animation)

func set_player(p : CharacterBody2D) -> void:
	self.player = p

func in_range() -> bool:
	return player && position.distance_to(player.position) < 500 && position.distance_to(player.position) > 150

func is_close() -> bool:
	return player && position.distance_to(player.position) < 300

func _on_hurt_box_body_entered(body: Node2D) -> void:
	pass
