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
	Sfx.play("book")
	if state == GuiState.BOOK:
		book.visible = false
		state = GuiState.DEFAULT
	elif state == GuiState.DEFAULT:
		book.visible = true
		state = GuiState.BOOK
