extends AudioStreamPlayer

@onready var music: AudioStream = load("res://assets/sounds/music/loop.wav")

func _on_finished():
	set_stream(music)
	play()

func swap_bus(plane: Globals.WorldPlane) -> void:
	match plane:
		Globals.WorldPlane.COGNITIVE:
			set_bus("Cognitive")
		Globals.WorldPlane.MATERIAL:
			set_bus("Master")
