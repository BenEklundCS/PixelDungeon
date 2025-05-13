extends Node2D
var Player = preload("res://Scenes/player.tscn")
const SpellCaster = preload("res://Scenes/Components/SpellCaster.tscn")

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
