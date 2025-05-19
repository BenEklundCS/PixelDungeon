extends Node2D

const Player = preload("res://Scenes/player.tscn")
const SpellCaster = preload("res://Scenes/Components/SpellCaster.tscn")

@export var spawn_player_x: float = 1390.0
@export var spawn_player_y: float = 1168.0
@export var spawn_player_scale: float = 3.0
@export var player_respawn_timer: float = 3.0

var player_dead: bool = false
var _player_respawn_timer: float = 0.0
var respawn_scale: float = 1.0

func _ready():
	respawn_scale = spawn_player_scale
	initialize_player()
	populate_player()

func _process(delta: float) -> void:
	if _player_respawn_timer > 0.0:
		_player_respawn_timer -= delta
	elif player_dead:
		respawn()
		player_dead = false

func initialize_player():
	if Global.player_instance == null:
		var player = Player.instantiate()
		player.name = "Player"
		player.scale = Vector2.ONE * spawn_player_scale
		Global.player_instance = player

	var player = Global.player_instance

	if player.get_parent():
		player.get_parent().remove_child(player)

	player.global_position = Vector2(spawn_player_x, spawn_player_y)
	player.scale = Vector2(spawn_player_scale, spawn_player_scale)
	add_child(player)
	$UI.set_player(player)

	# Spell Caster setup
	var spell_caster: Node = player.get_node_or_null("SpellCaster")
	if spell_caster == null:
		spell_caster = SpellCaster.instantiate()
		spell_caster.name = "SpellCaster"
		player.add_child(spell_caster)

	# Reconnect spawn_object signal
	if spell_caster.is_connected("spawn_object", Callable(self, "_on_spell_caster_spawn_object")):
		spell_caster.disconnect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))
	spell_caster.connect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))

	# Connect death signal
	if not player.is_connected("died", Callable(self, "_on_player_died")):
		player.connect("died", Callable(self, "_on_player_died"))

func respawn():
	var player = Player.instantiate()
	player.name = "Player"
	player.scale = Vector2(respawn_scale, respawn_scale)
	player.global_position = Vector2(spawn_player_x, spawn_player_y)
	add_child(player)
	$UI.set_player(player)

	# Replace the global reference with the new player
	Global.player_instance = player

	# Reattach SpellCaster
	var spell_caster = SpellCaster.instantiate()
	spell_caster.name = "SpellCaster"
	player.add_child(spell_caster)
	spell_caster.connect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))

	player.connect("died", Callable(self, "_on_player_died"))
	populate_player()

func populate_player() -> void:
	for _i in get_children():
		if "player" in _i:
			_i.set_player($Player)

func _on_player_died():
	print("Player has died")
	_player_respawn_timer = player_respawn_timer
	player_dead = true

func _on_spell_caster_spawn_object(object: Node):
	add_child(object)
