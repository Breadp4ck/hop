class_name Door
extends Item

func interact(spell: Spell) -> void:
	animator.play("Open")
	interactable = false
	
func disable() -> void:
	collision.disabled = true
	body_collision.disabled = true
