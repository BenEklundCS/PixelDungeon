extends "res://Scripts/Classes/enemy.gd"
const Player = preload("res://Scripts//player.gd")


@export var swing_cooldown: float = 2.0
var _cooldown: float = swing_cooldown


func _ready() -> void:
	$Animation.play()
	super._ready()

func _process(delta : float) -> void:
	super.basic_move(delta)
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

# Override the base NPC animation function
func handle_animation() -> void:
	# change animation
	if (velocity == Vector2.ZERO):
		$Animation.animation = "idle_base"
	else:
		$Animation.animation = "run_base"
	$Animation.play()
	flip($Animation)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	pass
