class_name Item
extends Node3D

signal interacted(with: Spell) # Calls when Player interacts with Item

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var body_collision: CollisionShape3D = $StaticBody3D/CollisionShape3D

@export var interactable: bool = false :
	set(value):
		if not interactable and value:
			self.interacted.connect(on_interact)
		elif interactable and not value:
			self.interacted.disconnect(on_interact)
		interactable = value
	get:
		return interactable

@export var needed_types_to_interact: Array[Globals.SpellType] = []

func on_interact(spell: Spell) -> void:
	if spell == null and needed_types_to_interact.size() == 0:
		interact(null)
		get_inversed_item().interact(null)
	elif spell != null and needed_types_to_interact.has(spell.type):
		interact(spell)
		get_inversed_item().interact(spell)

# Abstract methods
# --------------------------------------------------------------------------------------------------

func interact(spell: Spell) -> void:
	pass
	
func disable() -> void:
	pass

# --------------------------------------------------------------------------------------------------

func get_inversed_item() -> Item:
	var parent_name = get_parent().name
		
	if parent_name == "Material":
		return get_node("../../Cognitive/" + name)
	elif parent_name == "Cognitive":
		return get_node("../../Material/" + name)
	
	print("Cant find inversed item in " + parent_name)
	return null
