extends Node2D

@export var is_open = false
@export var target_scene: String
@export var spawn_position: Vector2 = Vector2(0, 0)

var player_nearby: bool = false
var _scene_change_queued := false

signal door_entered

func _ready():
	is_open = false

func _process(_delta: float) -> void:
	if player_nearby and !_scene_change_queued:
		if Input.is_action_just_pressed("interact"):
			_scene_change_queued = true
			door_entered.emit()
			call_deferred("change_scene_with_persistent_player")

func open_door():
	$DoorOpenedAudio.play()
	$DoorOpen.visible = true
	$DoorClosed.visible = false
	is_open = true

func close_door():
	$DoorClosedAudio.play()
	$DoorOpen.visible = false
	$DoorClosed.visible = true
	is_open = false

func _on_area_2d_body_entered(body: Node2D):
	if body.name == "Player":
		player_nearby = true
		open_door()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_nearby = false
		close_door()

func change_scene_with_persistent_player():
	if target_scene == "":
		return

	var current_scene = get_tree().current_scene
	var current_scene_path = current_scene.scene_file_path
	var player = Global.player_instance

	if current_scene_path == Global.overworld_scene_path:
		Global.last_overworld_position = player.global_position

	if player.get_parent():
		player.get_parent().remove_child(player)

	var new_scene = load(target_scene).instantiate()
	current_scene.queue_free()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

	var spawn_pos: Vector2
	if target_scene == Global.overworld_scene_path:
		spawn_pos = Global.last_overworld_position
	else:
		spawn_pos = spawn_position

	new_scene.add_child(player)
	player.global_position = spawn_pos

	_scene_change_queued = false
