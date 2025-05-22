extends Node

var player_scene: PackedScene = preload("res://Scenes/player.tscn")
var player_instance: Node2D = null
var last_overworld_position: Vector2 = Vector2.ZERO
var overworld_scene_path: String = "res://Scenes/game.tscn"


var defeated_enemies := {}

func _ready():
	if player_instance == null:
		player_instance = player_scene.instantiate()
		player_instance.name = "Player"

		# DO NOT add to scene tree yet. Will be added by game.gd or door.gd
