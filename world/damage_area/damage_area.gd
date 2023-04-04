extends Node

@export var damage: int = 0

func _on_area_entered(area: Area3D) -> void:
	area.owner.receive_damage(damage)
