extends Node2D

const Utils = preload("res://Scripts/utils.gd")

@export var mob: PackedScene = null # controls the scene this spawner is responsible for spawning instances of
@export var min_spawn_time: float = 5 # minimum time between spawns for rng
@export var max_spawn_time: float = 15 # maximum time between spawns for rng
@export var max_spawned: int = 3 # max # of mobs that can be active at any given time from this spawner
@export var respawn_on_death: bool = true
@export var debug: bool = false

var spawned_ids: Array[String] = [] # tracks which ids have been spawned by this spawner
var current_spawned: int = 0 # tracks how many mobs we've spawned so far

var spawn_timer: float = 0.0

func _ready() -> void:
	reset_timer()

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0 and current_spawned < max_spawned:
		spawn_mob()
		reset_timer()
func reset_timer() -> void:
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func spawn_mob() -> void:
	# instantiate an instance of the mob
	var new_mob: Node = mob.instantiate()
	var id: String = Utils.get_random_string(16)
	if debug:
		print("Creating new mob with id = " + str(id))
	# set attributes
	new_mob.scale = scale
	new_mob.position = position
	new_mob.enemy_id = id
	# connect signal for removal
	new_mob.connect("died_with_id", Callable(self, "_on_mob_died"))
	# add the mob to the spawner's parent's scene. This means spawners must live in the same node the Player and Monsters do FYI!
	get_parent().add_child(new_mob)
	# when a new mob is spawned, increment the current spawn count
	current_spawned += 1
	if debug:
		print("Spawned mob... Current spawned count = " + str(current_spawned))
	spawned_ids.append(id)

func _on_mob_died(id: String) -> void:
	if id in spawned_ids and respawn_on_death:
		spawned_ids.erase(id)
		current_spawned -= 1
		if debug:
			print("One of my tracked mobs died. Current spawned count = " + str(current_spawned))
