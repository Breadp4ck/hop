class_name InventoryItem
extends Item

enum Type{
	Book,
	Ring,
	Crystal
}

@export var type: Type

func interact_with_player() -> void:
	Inventory.pick_item(self)
