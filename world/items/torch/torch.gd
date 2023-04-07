class_name Torch
extends Item

@export var activatable_mechanisms: Mechanism

func interact(spell: Spell) -> void:
	# PARTICLEs HERE
	interactable = false
	
	activatable_mechanisms.activate()
	
func disable() -> void:
	pass
