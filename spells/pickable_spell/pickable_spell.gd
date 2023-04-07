extends Item

@export var type: Globals.SpellType

func interact(spell: Spell) -> void:
	var spell_caster: SpellCaster = get_tree().get_nodes_in_group("SpellCaster")[0]
	spell_caster.add_spell(type)
	
	queue_free()
