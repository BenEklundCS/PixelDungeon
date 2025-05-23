extends "res://Scripts/Interiors/base.gd"

func _ready() -> void:
	super._ready()
	$Player.set_light(true)
	$Background.play()

func _process(delta: float) -> void:
	super._process(delta)
	pass