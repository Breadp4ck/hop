extends Item

func interact(spell: Spell) -> void:
	animator.play("burn") 
	interactable = false
	
func disable() -> void:
	collision.disabled = true
	body_collision.disabled = true
	queue_free()
