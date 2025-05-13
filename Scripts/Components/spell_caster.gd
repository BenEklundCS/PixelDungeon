extends Node2D
const Spell = preload("res://Scripts/Classes/spell.gd")
const Combatant = preload("res://Scripts/Classes/combatant.gd")
signal spawn_object(velocity: Vector2)
var spells: Dictionary[String, Spell]

# bomb launcher component can be attached to another Scene in Godot
# Signal the Bomb Launcher to launch a bomb

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func get_spell(spell_name: String) -> Spell:
	return spells.get(spell_name)

func cast_spell(combatant: Combatant, spell_name: String, args: Array) -> void:
	var spell: Spell = get_spell(spell_name)
	if spell:
		if combatant.mana >= spell.cost:
			var spawned_object: Node = spell.cast(args)
			combatant.mana -= spell.cost
			print(spawned_object)
			spawn_object.emit(spawned_object)

func register_spell(spell_name: String, spell: Spell):
	spells.set(spell_name, spell)
