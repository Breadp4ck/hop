class_name SpellCaster
extends Node

signal choosed(spell: Globals.SpellType)
signal casted(spell: Spell)

@export var fire_spell_scene: PackedScene
@export var water_spell_scene: PackedScene
@export var wind_spell_scene: PackedScene
@onready var head: Node3D = $"../Head"

var choosen_spell_type: Globals.SpellType

func _process(delta) -> void: # REMOVE when add vocie spells.
	var spell_type = -1 as Globals.SpellType
	
	if Input.is_key_pressed(KEY_1):
		spell_type = (1-1) as Globals.SpellType
	elif Input.is_key_pressed(KEY_2):
		spell_type = (2-1) as Globals.SpellType
	elif Input.is_key_pressed(KEY_3):
		spell_type = (3-1) as Globals.SpellType
	
	if spell_type == -1:
		return
	
	choose(spell_type) 

func choose(spell_type: Globals.SpellType) -> void:
	if spell_type == -1 or World.current_plane == Globals.WorldPlane.MATERIAL:
		return
	
	choosen_spell_type = spell_type
	
	print("Choose spell " + Globals.SpellType.keys()[spell_type])
	choosed.emit(choosen_spell_type)
	
func try_cast_choosen() -> bool:
	if choosen_spell_type == null or World.current_plane == Globals.WorldPlane.MATERIAL:
		return false
	
	var spell = get_spell(choosen_spell_type)
	get_tree().get_root().add_child(spell)
	spell.global_position = head.global_position
	
	spell.move(head.global_transform.basis * Vector3.FORWARD)
	
	print("Cast spell " + Globals.SpellType.keys()[spell.type])
	casted.emit(spell)
	return true

func get_spell(spell_type: Globals.SpellType) -> Spell:
	match spell_type:
		Globals.SpellType.FIRE:
			return fire_spell_scene.instantiate()
		Globals.SpellType.WATER:
			return water_spell_scene.instantiate()
		Globals.SpellType.WIND:
			return wind_spell_scene.instantiate()
		_:
			return null
