extends Node2D
var Bomb: PackedScene = preload("res://Scenes/Objects/bomb.tscn")
const Spell = preload("res://Scripts/Classes/spell.gd")
const Combatant = preload("res://Scripts/Classes/combatant.gd")
signal spawn_object(velocity: Vector2)

var spells: Dictionary[String, Spell]

# bomb launcher component can be attached to another Scene in Godot
# Signal the Bomb Launcher to launch a bomb

func _ready() -> void:
	register_player_spells()
	pass

func _process(delta: float) -> void:
	pass

func get_spell(spell_name: String) -> Spell:
	return spells.get(spell_name)

func cast_spell(combatant: Combatant, spell_name: String, args: Array) -> void:
	var spell: Spell = get_spell(spell_name)
	if spell:
		if combatant.mana >= spell.cost:
			spell.cast(args)
			combatant.mana -= spell.cost

func register_player_spells():
	var launch_bomb = func launch_bomb(bomb_position: Vector2, bomb_velocity: Vector2) -> void:
		var bomb = Bomb.instantiate()
		bomb.scale *= 10
		bomb.velocity = bomb_velocity
		bomb.position = bomb_position
		spawn_object.emit(bomb)
	var throw_bomb_spell: Spell = Spell.new()
	var throw_bomb_cost: int = 1
	throw_bomb_spell.init(throw_bomb_cost, launch_bomb)
	spells.set("throw_bomb", throw_bomb_spell)




	
