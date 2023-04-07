extends Node

@export var spell_caster: SpellCaster
@export var animation_tree: AnimationTree

@onready var particles: GPUParticles3D = $GPUParticles3D

var state_machine

func _ready():
	state_machine = animation_tree.get("parameters/playback")
	
	spell_caster.choosed.connect(on_spell_chooosed)
	spell_caster.casted.connect(on_spell_casted)
	spell_caster.choose_canceled.connect(on_spell_choose_canceled)
	
func _on_tree_exited():
	spell_caster.choosed.disconnect(on_spell_chooosed)
	spell_caster.casted.disconnect(on_spell_casted)
	spell_caster.choose_canceled.disconnect(on_spell_choose_canceled)
	
func on_spell_chooosed(spell_type: Globals.SpellType) -> void:
	match spell_type:
		Globals.SpellType.FIRE:
			particles.process_material.color = Color.ORANGE
		Globals.SpellType.DESTRUCT:
			particles.process_material.color = Color.DODGER_BLUE
		Globals.SpellType.REPAIR:
			particles.process_material.color = Color.SLATE_BLUE
		Globals.SpellType.TELEPORT:
			particles.process_material.color = Color.MEDIUM_PURPLE
		Globals.SpellType.TIMESTOP:
			particles.process_material.color = Color.BLACK
		Globals.SpellType.LOCKPICK:
			particles.process_material.color = Color.LIGHT_CYAN
			
	state_machine.travel("OpenPalm")

func on_spell_casted(spell: Spell) -> void:
	state_machine.travel("Cast")
	
func on_spell_choose_canceled() -> void:
	state_machine.travel("Calm")
