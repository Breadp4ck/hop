extends Node

@export var destination_node: Node3D

func _on_area_entered(area: Area3D) -> void:
	if area.owner is Player:
		area.owner.global_position = destination_node.global_position
