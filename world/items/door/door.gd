class_name Door
extends Item

@onready var animator: AnimationPlayer = $AnimationPlayer

func interact(spell: Spell) -> void:
	animator.play("Open")
	interactable = false
