class_name Door
extends Item

func interact(spell: Spell) -> void:
	animator.play("Open")
	interactable = false
