# spell.gd
class_name Spell
extends Object

var cost: int
var spell: Callable
var projectile

func init(spell_cost: int, spell_func: Callable, spell_projectile_func) -> Spell:
	cost = spell_cost
	spell = spell_func
	projectile = spell_projectile_func
	return self

func cast():
	spell.call()

# return the projectile if it returns an object otherwise return None
func get_projectile(position: Vector2, velocity: Vector2):
	return projectile.call(position, velocity) if projectile else null
