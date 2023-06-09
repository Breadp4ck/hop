extends Node

@export var items: Array = []

func pick_item(inventory_item: InventoryItem):
	var inventory_item_types: Array = []
	for i in items.size():
		inventory_item_types.push_back(items[i].type)
	
	if inventory_item.type != InventoryItem.Type.CRYSTAL:
		if inventory_item_types.has(inventory_item.type) == false:
			items.append(inventory_item)
	else:
		items.append(inventory_item)
		
	inventory_item.global_position.y -= 1000000
	inventory_item.visible = false
