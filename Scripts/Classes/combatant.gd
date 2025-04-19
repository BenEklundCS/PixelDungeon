extends "res://Scripts/Classes/npc.gd"
# Combat stats
@export var hp: int = 50
@export var mana: int = 10
@export var armor: int = 0
@export var magic_armor: int = 0
@export var base_damage: int = 30

# Swing animation parameters
var swinging: bool = false
var swing_progress: float = 0.0
var swing_speed: float = 2.0
var max_swing_angle: float = 120.0  # Maximum angle of swing in degrees
var min_swing_angle: float = -30.0  # Starting position angle
var resting_angle: float = 0.0  # Angle when not swinging
var target_angle: float = 90.0    # Target angle when swinging

var hit: bool = false
var hit_timer: float = 0.0
var hit_timer_reset: float = 3.0

func _ready() -> void:
	# Set the initial position of the hand
	if has_node("Hand"):
		$Hand.rotation_degrees = resting_angle

func _process(delta: float) -> void:
	die() # check death and delete self if dead
	if hit:
		handle_hit(delta)
	if !has_node("Hand"):
		return  # Skip if Hand doesn't exist
		
	# Handle swinging with better animation curve
	if swinging:
		# Progress the swing
		swing_progress += delta * swing_speed
		if swing_progress >= 1.0:
			swing_progress = 1.0
			swinging = false
			
		# Use an ease-out curve for natural deceleration
		var curve = ease_out_quad(swing_progress)
		$Hand.rotation_degrees = lerp(min_swing_angle, max_swing_angle, curve)
	else:
		# Return to resting position
		if $Hand.rotation_degrees > resting_angle:
			# Smooth return to resting
			$Hand.rotation_degrees = lerp($Hand.rotation_degrees, resting_angle, delta * 5.0)

# Easing function for more natural movement
func ease_out_quad(x: float) -> float:
	return 1.0 - (1.0 - x) * (1.0 - x)

# Start a weapon swing with natural movement
func swing(power: float = 1.0):
	if has_node("Hand"):
		swinging = true
		swing_progress = 0.0
		# Adjust swing speed based on power
		swing_speed = 2.0 + power

func die():
	if hp <= 0:
		queue_free()

func rst_hit():
	hit_timer = hit_timer_reset
	hit = true

func hurt(damage: int, type: int) -> void:
	if (!hit):
		rst_hit()
		if type == Utils.damage_type.MAGIC:
			hp -= damage - magic_armor
		else:
			hp -= damage - armor

func handle_hit(delta: float) -> void:
	hit_timer -= delta
	
	# For 6 flashes in 3 seconds, each complete cycle is 0.5 seconds
	# (3.0 seconds / 6 flashes = 0.5 seconds per flash)
	var flash_cycle = 0.5
	var flash_half_cycle = flash_cycle / 2
	
	# Use modulo to determine which part of the cycle we're in
	var cycle_position = fmod(hit_timer, flash_cycle)
	
	# First half of cycle is red, second half is normal
	if cycle_position > flash_half_cycle:
		$Animation.modulate = Color(1, 0, 0)  # Red
	else:
		$Animation.modulate = Color(1, 1, 1)  # Normal
	
	# Check if the hit timer has expired
	if hit_timer <= 0:
		hit = false
		$Animation.modulate = Color(1, 1, 1)  # Reset to normal color

func check_for_hits() -> Array[Node2D]:
	var bodies = $HurtBox.get_overlapping_bodies()
	return bodies

