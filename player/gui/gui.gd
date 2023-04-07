class_name GUI
extends Control

@onready var book: Control = $Book
@onready var hud: Control = $HUD
@onready var pause: Control = $Pause

enum GuiState {
	DEFAULT,
	PAUSE,
	BOOK,
}

var state: GuiState = GuiState.DEFAULT


func _ready() -> void:
	book.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("book"):
		toggle_book()


func toggle_book() -> void:
	var inventory_item_types: Array = []
	for i in Inventory.items.size():
		inventory_item_types.push_back(Inventory.items[i].type)
	if not inventory_item_types.has(InventoryItem.Type.BOOK):
		return

	if state == GuiState.BOOK:
		book.visible = false
		state = GuiState.DEFAULT
	elif state == GuiState.DEFAULT:
		book.visible = true
		state = GuiState.BOOK
