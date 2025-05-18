extends StaticBody2D
@export var scene: String

func _on_door_door_entered():
	if scene:
		get_tree().change_scene_to_file(scene)

