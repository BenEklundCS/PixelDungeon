extends Node2D
var player = preload("res://Scenes/player.tscn")

var player_dead: bool = false
var _player_respawn_timer: float = 0.0
@export var player_respawn_timer: float = 3.0
var respawn_scale: float = 1.0

func _ready():
	# if an object implements player storage, pass it the player
	populate_player()
	respawn_scale = $Player.scale.x

func _process(_delta):
	if _player_respawn_timer > 0.0:
		_player_respawn_timer -= _delta
	else:
		if player_dead:
			respawn()
			player_dead = false

func populate_player() -> void:
	for _i in self.get_children():
		if "player" in _i:
			_i.set_player($Player)


func respawn() -> void:
	var p = player.instantiate()
	p.scale *= respawn_scale
	add_child(p)
	p.connect("died", Callable(self, "_on_player_died"))
	populate_player()

func _on_player_died() -> void:
	_player_respawn_timer = player_respawn_timer
	player_dead = true
