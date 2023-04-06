extends Item

func interact(spell: Spell) -> void:
	animator.play("Restore")
	interactable = false
	
func disable() -> void: # Invoke this at and of animation
	collision.disabled = true
	body_collision.disabled = true
