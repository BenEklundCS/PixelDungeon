extends Node2D
var Player = preload("res://Scenes/player.tscn")
const SpellCaster = preload("res://Scenes/Components/SpellCaster.tscn")

var player_dead: bool = false
var _player_respawn_timer: float = 0.0
@export var player_respawn_timer: float = 3.0
@export var spawn_player_x: int = 1390.0
@export var spawn_player_y: int = 1168.0
@export var spawn_player_scale: int = 3
var respawn_scale: float = 1.0

func _ready():
	initialize_player()
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

func initialize_player() -> void:
	# spawn the player and add them to globals
	if Global.player_instance == null:
		var player = Global.player_scene.instantiate()
		var spell_caster = SpellCaster.instantiate()
		player.add_child(spell_caster)
		player.scale *= spawn_player_scale
		player.connect("died", Callable(self, "_on_player_died"))
		spell_caster.connect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))
		Global.player_instance = player
		add_child(player)
		player.global_position = Vector2(spawn_player_x, spawn_player_y) # starting position
	else:
		add_child(Global.player_instance)
		Global.player_instance.global_position = Vector2(spawn_player_x, spawn_player_y)

func populate_player() -> void:
	for _i in self.get_children():
		if "player" in _i:
			_i.set_player($Player)

func respawn() -> void:
	# respawn the player by instantiating a new player object
	var player = Player.instantiate()
	# scale the player correctly
	player.scale *= respawn_scale
	# add the player as a child to the scene
	add_child(player)
	# connect the player respawn event to the scene
	player.connect("died", Callable(self, "_on_player_died"))

	# instantiate the player's bomb launcher component
	var spell_caster = SpellCaster.instantiate()
	# attach the component to the player
	player.add_child(spell_caster)
	# connect the bomb spawning event to the scene
	spell_caster.connect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))
	populate_player()

func _on_player_died() -> void:
	print("Player has died")
	_player_respawn_timer = player_respawn_timer
	player_dead = true

func _on_spell_caster_spawn_object(object: Node) -> void:
	add_child(object)
