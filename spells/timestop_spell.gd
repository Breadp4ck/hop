class_name TimestopSpell
extends Spell

func _ready() -> void:
	stop_enemies(duration)

func stop_enemies(duration: float) -> void:
	pass

func _on_area_entered(area) -> void:
	print("Hit " + area.get_name() + " area.")
