extends Control

@onready var header_label: Label = $MarginContainer/VBoxContainer/Header
@onready var text_label: RichTextLabel = $MarginContainer/VBoxContainer/RichTextLabel


@export var show_last: bool = false # Show last added page

var list_sequence: Array = []
var current_page: int = 0


func _ready() -> void:
	add_page("The Book", "It's a magic book of magic. Here you can write down all your spells that you can think of. But it's hard to think, so it would be better if someone wrote them for you. Any spells you find will be added to this book. You may open the book with the ★TAB★ key")
	add_page("The Planes", "The whole world consists of two planes, the material and the cognitive. They duplicate each other, but with some peculiarities. The cognitive element is populated by the spirits of objects and beings, expressing certain traits of them.")
	add_page("The Ring", "The ring allows you to move between worlds by pressing the ★Space★ key. The ring also allows you to cast spells, but unfortunately only in cognitive reality (plane). To cast a spell, press the ★C★ key.")
	
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
