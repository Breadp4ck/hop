class_name Item
extends Node3D


signal interacted(plane, with) # Calls when Player interacts with Item

@export var interactable: bool = false :
	set(value):
		if not interactable and value:
			self.interacted.connect(on_interact)
		elif interactable and not value:
			self.interacted.disconnect(on_interact)
	get:
		return interactable


func on_interact(with: Item) -> void:
	if with != null:
		interact_with_item(with)
	else:
		interact_with_player()


# Abstract methods
# --------------------------------------------------------------------------------------------------

# Abstract method called when 2 items have interacted
func interact_with_item(with: Item) -> void:
	pass

# Abstract method called when player has interacted with item
func interact_with_player() -> void:
	pass
