class_name EndGameScreen
extends Node

var enabled: bool = false

func _process(delta):
	if Input.is_action_just_pressed("jump_to_plane") and enabled:
		get_tree().quit()


func enable() -> void:
	enabled = true
	self.visible = true
