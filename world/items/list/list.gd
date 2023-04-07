class_name List
extends Item

@export var pickable_spell_type: Globals.SpellType = -1
@export var title: String
@export var text: String

func interact(spell: Spell) -> void:
	var book_ui: BookUI = get_tree().get_nodes_in_group("BookUI")[0]
		
	if pickable_spell_type != -1:
		var spell_caster: SpellCaster = get_tree().get_nodes_in_group("SpellCaster")[0]
		spell_caster.add_spell(pickable_spell_type)
	
	var book_texts: Array = []
	for page in book_ui.list_sequence:
		if page["title"] == title:
			queue_free()
			return
	
	Sfx.play("book_newpage")
	book_ui.add_page(title, text)
	queue_free()
