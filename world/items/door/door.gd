class_name Door
extends Item

@onready var animator: AnimationPlayer = $AnimationPlayer

func interact_with_spell(spell: Spell) -> void:
	animator.play("Open")
	interactable = false
