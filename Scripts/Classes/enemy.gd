extends "res://Scripts/Classes/combatant.gd" # inherit from npc.gd

# enemy is a class layer between combatant and implementation
# add traits common to all enemies, but not needed on all combatants here

var player: CharacterBody2D = null
var target_position: Vector2 = Vector2(0, 0)
var destination_reached: bool = false
var idle_timer: float = 0.0
var idle_duration: float = 3.0
@export var move_range: int = 300
@export var attack_range: int = 100
@export var max_coins_dropped: int = 15
@export var enemy_id: String
var coin_base_offset: int = 50

signal died_with_id(id: String)

var Coin: PackedScene = preload("res://Scenes/Objects/coin.tscn")

func _ready() -> void:
	target_position = Utils.get_random_position_in_range(position, move_range)
	if Global.defeated_enemies.has(enemy_id):
		queue_free()
	super._ready()
	pass

func _process(delta: float) -> void:
	super._process(delta)
	pass

# override the die method on enemies such that they drop coins
func die() -> void:
	if hp <= 0:
		spawn_coins()
		# emit died and free the node
		died.emit()
		died_with_id.emit(enemy_id)
		Global.defeated_enemies[enemy_id] = true
		queue_free()	

func spawn_coins() -> void:
	var how_many = randi_range(1, max_coins_dropped)
	for _i in how_many:
		var rand_offset = Vector2(
			randi_range(-coin_base_offset, coin_base_offset), 
			randi_range(-coin_base_offset, coin_base_offset))
		var coin = Coin.instantiate()
		coin.position = position + rand_offset
		coin.scale *= 3
		get_tree().root.add_child(coin)


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
