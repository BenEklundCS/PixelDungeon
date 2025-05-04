extends Node2D
signal spawn_bomb(velocity: Vector2)

# bomb launcher component can be attached to another Scene in Godot
# Signal the Bomb Launcher to launch a bomb

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func launch_bomb(bomb_position: Vector2, velocity: Vector2) -> void:
	spawn_bomb.emit(bomb_position, velocity)

	"""
	var new_bomb = bomb.instantiate()
	new_bomb.velocity = velocity
	var behavior_node = get_node("/Root/Behaviors")
	behavior_node.add_child(new_bomb)
	"""
	
