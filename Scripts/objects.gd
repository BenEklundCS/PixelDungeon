extends Node2D

func _ready():
	# if an object implements player storage, pass it the player
	for _i in self.get_children():
		if "player" in _i:
			_i.set_player($Player)

func _process(_delta):
	"""
	for child in get_children():
		if child is Node2D:
			child.z_index = int(child.global_position.y)
	"""
