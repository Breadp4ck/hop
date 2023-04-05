extends Node

@export var items = {}

func _ready() -> void:
	for i in InventoryItem.Type.values().size():
		items[i as InventoryItem.Type] = false

func pick_item(inventory_item: InventoryItem):
	items[inventory_item.type] = true
	
	inventory_item.queue_free()
	inventory_item.get_inversed_item().queue_free()
