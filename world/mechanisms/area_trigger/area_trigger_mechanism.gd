extends Mechanism

func _on_area_entered(area) -> void:
	if area.owner is Player:
		activate()

func use() -> void:
	print("use")
	pass
