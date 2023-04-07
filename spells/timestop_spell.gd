class_name TimestopSpell
extends Spell

func _ready() -> void:
	stop_enemies(duration)

func stop_enemies(duration: float) -> void:
	# Stop enemies.
	pass

func _on_area_entered(area) -> void:
	pass

func end() -> void:
	# UnStop enemies.
	destroy()
