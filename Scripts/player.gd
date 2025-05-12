extends "res://Scripts/Classes/combatant.gd"
const Enemy = preload("res://Scripts/Classes/enemy.gd")
const SpellCaster = preload("res://Scripts/Components/spell_caster.gd")
const Bomb: PackedScene = preload("res://Scenes/Objects/bomb.tscn")
const Skeleton: PackedScene = preload("res://Scenes/Enemies/skeleton.tscn")

var screen_size: Vector2 # game window size
var attacking: bool = false
var spell_caster: SpellCaster = null

@export var throw_velocity: Vector2 = Vector2(500, -1000)
@export var spawn_scale: int = 3

func _ready() -> void:
	screen_size = get_viewport_rect().size
	speed = 650
	get_spellcaster()

func _process(delta: float) -> void:
	move(delta)

	handle_swing()
	handle_player_input()
	
	super._process(delta)

func get_spellcaster():
	for node in get_children():
		# init spellcaster
		if node is SpellCaster:
			spell_caster = node
			register_player_spells()
	if spell_caster == null:
		print("FAILED TO LOAD SPELL_CASTER ON PLAYER")
	
func handle_animation() -> void:
	# change animation
	if (velocity == Vector2.ZERO):
		$Animation.animation = "idle"
	else:
		$Animation.animation = "run"
	$Animation.play()
	flip($Animation)

func move(delta: float) -> void:
	# find movement Utils.direction to add to velocity
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		facing = Utils.direction.RIGHT
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		facing = Utils.direction.LEFT
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed

	handle_animation()

	# move the player's position
	move_and_collide(velocity * delta)

func attack() -> void:
	super.swing(power)
	var bodies: Array[Node2D] = check_for_hits()
	if bodies:
		for body in bodies:
			if body is Enemy:
				body.hurt(base_damage, Utils.damage_type.PHYSICAL)

func handle_player_input():
	if Input.is_action_pressed("attack"):
		attack()

	if Input.is_action_just_pressed("throw_bomb"):
		var temp_velocity: Vector2 = Vector2(throw_velocity.x * (1 if facing == Utils.direction.RIGHT else -1), throw_velocity.y)
		spell_caster.cast_spell(self, "throw_bomb", [position, temp_velocity])

	if Input.is_action_just_pressed("summon_skeleton"):
		spell_caster.cast_spell(self, "summon_skeleton", [position])

func handle_swing():
	if swinging:
		$HurtBox.monitoring = true
	else:
		$HurtBox.monitoring = false

func register_player_spells():
	# define launch_bomb lambda function for the spell definition
	var launch_bomb = func launch_bomb(bomb_position: Vector2, bomb_velocity: Vector2) -> Node:
		var bomb = Bomb.instantiate()
		bomb.scale *= spawn_scale
		bomb.velocity = bomb_velocity
		bomb.position = bomb_position
		return bomb
	# define spell object
	var throw_bomb_spell: Spell = Spell.new()
	var throw_bomb_cost: int = 1
	# initialize spell
	throw_bomb_spell.init(throw_bomb_cost, launch_bomb)
	spell_caster.register_spell("throw_bomb", throw_bomb_spell)

	# define summon_skeleton lambda function for the spell definition
	var summon_skeleton = func summon_skeleton(skeleton_position: Vector2) -> Node:
		var skeleton = Skeleton.instantiate()
		skeleton.player = self
		skeleton.position = skeleton_position
		skeleton.scale *= spawn_scale
		return skeleton
	# define spell object
	var summon_skeleton_spell: Spell = Spell.new()
	var summon_skeleton_cost: int = 2
	# initialize spell
	summon_skeleton_spell.init(summon_skeleton_cost, summon_skeleton)
	spell_caster.register_spell("summon_skeleton", summon_skeleton_spell)

func _on_hurt_box_body_entered(_body:Node2D) -> void:
	pass
