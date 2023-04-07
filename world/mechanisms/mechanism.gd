class_name Mechanism
extends Node

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var body_collision: CollisionShape3D = $StaticBody3D/CollisionShape3D

@export var activates_needed: int = 1
var activates_amount: int = 0

func activate() -> void:
	activates_amount += 1
	if activates_amount < activates_needed:
		return
	
	use()
	get_inversed_mechanism().use

func use() -> void:
	pass

func end() -> void:
	pass

func get_inversed_mechanism() -> Mechanism:
	var parent_name = get_parent().name
		
	if parent_name == "Material":
		return get_node("../../Cognitive/" + name)
	elif parent_name == "Cognitive":
		return get_node("../../Material/" + name)
	
	print("Cant find inversed mechanism in " + parent_name)
	return null
