extends "res://Scripts/Classes/npc.gd"

var player: CharacterBody2D = null

func _ready() -> void:
	$Animation.play()

func handle_animation():
	if facing == Utils.direction.UP:
		$Animation.animation = "up"
	if facing == Utils.direction.DOWN:
		$Animation.animation = "down"
	if facing == Utils.direction.LEFT:
		$Animation.animation = "left"
	if facing == Utils.direction.RIGHT:
		$Animation.animation = "right"
		

func _process(delta : float) -> void:
	# movement logic
	if player && position.distance_to(player.position) > 200:
		$Animation.play()
		move_towards(player.position, delta, true)
	else:
		$Animation.stop()

func in_range() -> bool:
	return player && position.distance_to(player.position) < 500 && position.distance_to(player.position) > 100

func set_player(p : CharacterBody2D) -> void:
	self.player = p
