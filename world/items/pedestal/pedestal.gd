extends Item

@export var crystal: Node3D
@export var portal: Portal
	
var has_crystal: bool = false

func interact(spell: Spell) -> void:
	var inventory_item_types: Array = []
	for i in Inventory.items.size():
		inventory_item_types.push_back(Inventory.items[i].type)
	
	if inventory_item_types.has(InventoryItem.Type.CRYSTAL) == false:
		return
	
	var crystal_items: Array = []
	for i in Inventory.items.size():
		if Inventory.items[i].type == InventoryItem.Type.CRYSTAL:
			crystal_items.push_back(Inventory.items[i])
	
	Inventory.items.erase(crystal_items[0])
	
	interactable = false
	
	has_crystal = true
	crystal.visible = true
	
	portal.add_one_crystal()
