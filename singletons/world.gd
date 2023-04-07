extends Node3D

var current_plane: Globals.WorldPlane 

func invert_plane() -> void:
	current_plane = (current_plane + 1) % 2
	Music.swap_bus(current_plane)
