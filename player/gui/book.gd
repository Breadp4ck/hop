extends Control

@onready var header_label: Label = $MarginContainer/VBoxContainer/Header
@onready var text_label: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel


@export var show_last: bool = false # Show last added page

var list_sequence: Array = []
var current_page: int = 0


func _ready() -> void:
	add_page("The Book", "some text")
	add_page("The World", "some text")
	add_page("The Planes", "some text")
	add_page("The Ring", "some text")
	
	show_page(first_page())


func add_page(title: String, text: String):
	list_sequence.push_back({"title": title, "text": text})
	if show_last:
		show_page(last_page())


func pages_total() -> int:
	return list_sequence.size()


func first_page() -> Dictionary:
	current_page = 0
	return list_sequence[current_page]


func last_page() -> Dictionary:
	current_page == pages_total() - 1
	return list_sequence[current_page]


func next_page() -> Dictionary:
	if current_page == pages_total() - 1:
		current_page = 0
	else:
		current_page += 1
	
	return list_sequence[current_page]


func previous_page() -> Dictionary:
	if current_page == 0:
		current_page = pages_total() - 1
	else:
		current_page -= 1
	
	return list_sequence[current_page]


func show_page(page: Dictionary) -> void:
	header_label.text = page["title"]
	text_label.text = page["text"]


func _on_prev_page_button_pressed() -> void:
	var page := previous_page()
	show_page(page)


func _on_next_page_button_pressed() -> void:
	var page := next_page()
	show_page(page)
