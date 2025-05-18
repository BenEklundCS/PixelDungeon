extends Node2D
@export var is_open = false
signal door_entered

func _ready():
	is_open = false
	print("loaded door")
	#open_door()

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
	print("opening door")
	open_door()
	door_entered.emit()


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("closing door")
	close_door()
