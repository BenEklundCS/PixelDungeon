extends Node2D
const Utils = preload("res://Scripts/utils.gd")
const Bomb = preload("res://Scripts/Objects/bomb.gd")
var player = preload("res://Scenes/player.tscn")
var SpellCaster: PackedScene = preload("res://Scenes/Components/SpellCaster.tscn")

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
	var spell_caster = SpellCaster.instantiate()
	# attach the component to the player
	p.add_child(spell_caster)
	# connect the bomb spawning event to the scene
	spell_caster.connect("spawn_bomb", Callable(self, "_on_spell_caster_spawn_bomb"))
	
	populate_player()

func _on_player_died() -> void:
	_player_respawn_timer = player_respawn_timer
	player_dead = true

# spell caster component may notify the game a spell was cast. If the spell includes a projectile
# this observer is notified and adds the projectile to the scene
func _on_spell_caster_notify_cast_spell(projectile: Node) -> void:
	if projectile:
		add_child(projectile)
