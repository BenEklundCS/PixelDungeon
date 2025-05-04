extends Node2D
var player = preload("res://Scenes/player.tscn")
var Bomb: PackedScene = preload("res://Scenes/Objects/bomb.tscn")
var Bomb_Launcher: PackedScene = preload("res://Scenes/Components/BombLauncher.tscn")

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
	# respawn the player by instantiating a new player object
	var p = player.instantiate()
	# scale the player correctly
	p.scale *= respawn_scale
	# add the player as a child to the scene
	add_child(p)
	# connect the player respawn event to the scene
	p.connect("died", Callable(self, "_on_player_died"))

	# instantiate the player's bomb launcher component
	var bomb_launcher = Bomb_Launcher.instantiate()
	# attach the component to the player
	p.add_child(bomb_launcher)
	# connect the bomb spawning event to the scene
	bomb_launcher.connect("spawn_bomb", Callable(self, "_on_bomb_launcher_spawn_bomb"))
	

	populate_player()

func _on_player_died() -> void:
	_player_respawn_timer = player_respawn_timer
	player_dead = true

func _on_bomb_launcher_spawn_bomb(bomb_position: Vector2, velocity: Vector2) -> void:
	print("spawning bomb.")
	var bomb = Bomb.instantiate()
	bomb.scale *= 10
	bomb.velocity = velocity
	bomb.position = bomb_position
	add_child(bomb)