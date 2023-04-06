class_name InventoryItem
extends Item

enum Type{
	BOOK,
	RING,
	CRYSTAL
}

@export var type: Type

func interact(spell: Spell) -> void:
	if spell == null:
		Inventory.pick_item(self)
