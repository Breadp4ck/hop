class_name Item
extends Node3D

signal interacted(with: Spell) # Calls when Player interacts with Item

@export var interactable: bool = false :
	set(value):
		if not interactable and value:
			self.interacted.connect(on_interact)
		elif interactable and not value:
			self.interacted.disconnect(on_interact)
		interactable = value
	get:
		return interactable

@export var needed_types_to_interact: Array[Globals.SpellType] = []

func on_interact(spell: Spell) -> void:
	if spell != null:
		for i in spell.types:
			if needed_types_to_interact.has(i):
				interact_with_spell(spell)
				break
	else:
		interact_with_player()

# Abstract methods
# --------------------------------------------------------------------------------------------------

# Abstract method called when spell have interacted with item
func interact_with_spell(spell: Spell) -> void:
	pass

# Abstract method called when player has interacted with item
func interact_with_player() -> void:
	pass
