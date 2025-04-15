extends "res://Scripts/Classes/npc.gd"

# combatant provides interfaces for combat on top of the NPC layer
# this class implements combat stats for all characters as well as methods for hitting them

@export var hp: int
@export var mana: int
@export var armor: int
@export var magic_armor: int

# returns True if the character is currently dead otherwise False
func is_dead() -> bool:
	return hp <= 0
	
# hits the enemy for damage, and returns damage factored with armor
# if the damage type is magic, magic armor is used
# if the damage type is physical, physical armor is used
func hit(damage: int, type: int) -> int:
	var dealt = 0
	if type == Utils.damage_type.PHYSICAL:
		dealt = damage - armor
		hp -= dealt
	elif type == Utils.damage_type.MAGIC:
		dealt = damage - magic_armor
		hp -= dealt
	return dealt

