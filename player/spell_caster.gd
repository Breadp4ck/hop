class_name SpellCaster
extends Node

signal choosed(spell: Globals.SpellType)
signal casted(spell: Spell)
signal choose_canceled()

@export var fire_spell_scene: PackedScene
@export var water_spell_scene: PackedScene
@export var wind_spell_scene: PackedScene
@export var repair_spell_scene: PackedScene
@export var timestop_spell_scene: PackedScene
@export var teleport_spell_scene: PackedScene
@onready var head: Node3D = $"../Head"

var choosen_spell_type: Globals.SpellType = -1

var available_spell_types: Array = []

func add_spell(spell_type: Globals.SpellType) -> void:
	available_spell_types.append(spell_type)

func choose(spell_type: Globals.SpellType) -> void:
	if can_conjure(spell_type) == false:
		Sfx.play("spell_failed")
		return
	if spell_type == -1:
		return
		
	Sfx.play("spell_succ")
	choosen_spell_type = spell_type
	
	print("Choose spell " + Globals.SpellType.keys()[spell_type])
	choosed.emit(choosen_spell_type)

func cancel_choose() -> void:
	choosen_spell_type = -1
	choose_canceled.emit()

func try_cast_choosen() -> bool:
	if can_conjure(choosen_spell_type) == false:
		return false
	
	if choosen_spell_type == -1:
		return false
	
	var spell = get_spell(choosen_spell_type)
	get_tree().get_root().add_child(spell)
	spell.global_position = head.global_position
	
	spell.move(head.global_transform.basis * Vector3.FORWARD)
	
	print("Cast spell " + Globals.SpellType.keys()[spell.type])
	casted.emit(spell)
	return true

func get_spell(spell_type: Globals.SpellType) -> Spell:
	if can_conjure(spell_type) == false:
		return
	
	match spell_type:
		Globals.SpellType.FIRE:
			return fire_spell_scene.instantiate()
		Globals.SpellType.WATER:
			return water_spell_scene.instantiate()
		Globals.SpellType.WIND:
			return wind_spell_scene.instantiate()
		Globals.SpellType.REPAIR:
			return repair_spell_scene.instantiate()
		Globals.SpellType.TIMESTOP:
			return timestop_spell_scene.instantiate()
		Globals.SpellType.TELEPORT:
			return teleport_spell_scene.instantiate()
		_:
			return null
			
func can_conjure(spell_type: Globals.SpellType) -> bool:
	var inventory_item_types: Array = []
	for i in Inventory.items.size():
		inventory_item_types.push_back(Inventory.items[i].type)
	
	if not inventory_item_types.has(InventoryItem.Type.BOOK) or not inventory_item_types.has(InventoryItem.Type.RING) or World.current_plane != Globals.WorldPlane.COGNITIVE:
		return false
		
	if not available_spell_types.has(spell_type):
		return false
		
	return true
