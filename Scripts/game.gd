extends Node2D

@export var spawn_player_x: float = 1390.0
@export var spawn_player_y: float = 1168.0
@export var spawn_player_scale: float = 3.0

const SpellCaster = preload("res://Scenes/Components/SpellCaster.tscn")

func _ready():
	spawn_player()

func spawn_player():
	var player = Global.player_instance

	if player.get_parent():
		player.get_parent().remove_child(player)

	player.global_position = Vector2(spawn_player_x, spawn_player_y)
	player.scale = Vector2(spawn_player_scale, spawn_player_scale)

	$UI.set_player(player)
	add_child(player)

	var spell_caster: Node = player.get_node_or_null("SpellCaster")
	if spell_caster == null:
		spell_caster = SpellCaster.instantiate()
		spell_caster.name = "SpellCaster"
		player.add_child(spell_caster)

	# Always (re)connect signal from SpellCaster to this Game node
	if spell_caster.is_connected("spawn_object", Callable(self, "_on_spell_caster_spawn_object")):
		spell_caster.disconnect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))
	spell_caster.connect("spawn_object", Callable(self, "_on_spell_caster_spawn_object"))

	if not player.is_connected("died", Callable(self, "_on_player_died")):
		player.connect("died", Callable(self, "_on_player_died"))


func _on_player_died():
	print("Player has died")
	# Handle death logic if needed

func _on_spell_caster_spawn_object(object: Node):
	add_child(object)
