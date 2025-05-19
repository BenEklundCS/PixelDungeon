extends StaticBody2D
@export var scene: String

func _ready() -> void:
	$Door.target_scene = scene

func _on_door_door_entered():
	pass
