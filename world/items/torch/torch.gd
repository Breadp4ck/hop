class_name Torch
extends Item

@onready var anim: AnimationPlayer = $AnimationPlayer

@export var activatable_mechanisms: Mechanism

func interact(spell: Spell) -> void:
	anim.play("burn")
	interactable = false
	
	activatable_mechanisms.activate()
	
func disable() -> void:
	pass
