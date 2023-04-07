extends Item

@export var activatable_mechanisms: Mechanism

func interact(spell: Spell) -> void:
	animator.play("Press")
	Sfx.play("button_pressed")
	interactable = false
	
	activatable_mechanisms.activate()
