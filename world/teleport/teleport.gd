extends Node

@export var destination_marker: Marker3D


func _on_area_entered(area: Area3D) -> void:
	if area.owner is Player:
		area.owner.effects.play("fade")
		await get_tree().create_timer(0.5).timeout
		area.owner.global_position = destination_marker.global_position


func _on_area_exited(area: Area3D) -> void:
	if area.owner is Player:
		area.owner.global_position = destination_marker.global_position
