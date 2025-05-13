extends "res://Scripts/Classes/combatant.gd" # inherit from npc.gd

# enemy is a class layer between combatant and implementation
# add traits common to all enemies, but not needed on all combatants here

var player: CharacterBody2D = null
var target_position: Vector2 = Vector2(0, 0)
var destination_reached: bool = false
var idle_timer: float = 0.0
var idle_duration: float = 3.0
@export var move_range = 300
@export var attack_range = 100

func _ready() -> void:
	target_position = Utils.get_random_position_in_range(position, move_range)
	super._ready()
	pass

func _process(delta: float) -> void:
	super._process(delta)
	pass

func in_range() -> bool:
	return player && position.distance_to(player.position) < 500 && position.distance_to(player.position) > 150

func is_close() -> bool:
	return player && position.distance_to(player.position) < attack_range

func basic_move(delta: float) -> void:
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

func set_player(p: CharacterBody2D) -> void:
	self.player = p
	# Force the enemy to reevaluate its target position
	if player && in_range():
		target_position = player.position
		destination_reached = false
