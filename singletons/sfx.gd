extends AnimationPlayer

@onready var scene: PackedScene = preload("res://singletons/generic_stream_player.tscn")

func play_sound(stream: AudioStream):
	var instance = scene.instantiate()
	add_child(instance)
	instance.stream = stream
	instance.play()
