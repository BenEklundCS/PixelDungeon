extends "res://Scripts/Interiors/base.gd"

func _ready():
	respawn_scale = spawn_player_scale
	initialize_player()
	$Player.set_light(false)
	populate_player()
