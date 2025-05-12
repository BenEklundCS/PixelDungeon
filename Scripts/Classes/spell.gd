# spell.gd
class_name Spell
extends Object

var cost: int
var spell: Callable
var projectile

func init(spell_cost: int, spell_func: Callable) -> Spell:
	cost = spell_cost
	spell = spell_func
	return self

func cast(args: Array) -> Node:
	return spell.callv(args)
