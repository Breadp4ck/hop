extends Item

func interact(spell: Spell) -> void:
	# PARTICLEs
	interactable = false
	
func disable() -> void:
	collision.disabled = true
	body_collision.disabled = true
	queue_free()
