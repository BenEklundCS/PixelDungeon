extends Control

func start_game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_button_pressed() -> void:
	start_game()
