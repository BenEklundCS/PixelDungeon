extends Node2D
@export var is_open = false

func _ready():
	is_open = false
	#open_door()

func open_door():
	$DoorOpen.visible = true
	$DoorClosed.visible = false
	is_open = true

func close_door():
	$DoorOpen.visible = false
	$DoorClosed.visible = true
	is_open = false

func _on_area_2d_body_entered(area):
	open_door()


func _on_area_2d_body_exited(body: Node2D) -> void:
	close_door()
