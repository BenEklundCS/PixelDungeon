extends "res://Scripts/Interiors/base.gd"

func _ready() -> void:
	super._ready()
	$Background.play()

func _process(delta: float) -> void:
	super._process(delta)
	pass