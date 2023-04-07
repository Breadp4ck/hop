class_name List
extends Item

@export var title: String
@export var text: String

func interact(spell: Spell) -> void:
	var book_ui: BookUI = get_tree().get_nodes_in_group("BookUI")[0]
	
	var book_texts: Array = []
	for i in book_ui.list_sequence.size():
		book_texts.push_back(book_ui.list_sequence[i])
		
	if (book_texts.has(text) == false):
		book_ui.add_page(title, text)
	
	queue_free()
