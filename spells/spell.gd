class_name Spell
extends Node

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape3D = $CollisionShape3D

@export var type: Globals.SpellType
@export var length: float = 3.0
@export var duration: float = 1.0

var destination_position: Vector3
var transition_tween: Tween

func move(direction: Vector3) -> void:
	transition_tween = create_tween()
	destination_position = self.global_position + direction * length * Globals.TILE_LENGTH
	transition_tween.tween_property(self, "global_position", destination_position, duration)
	transition_tween.finished.connect(on_tween_transition_finished)
	
	start()
	
func on_tween_transition_finished() -> void:
	transition_tween.finished.disconnect(on_tween_transition_finished)
	end()

func _on_area_entered(area) -> void:
	print("Hit " + area.get_name() + " area.")
	end()
	if area is Item and area.interactable:
		area.interacted.emit(self)
	elif area is Shadow:
		area.interact_with_spell(self)

func start() -> void:
	pass

func end() -> void:
	transition_tween.stop()
	animator.play("end")

func destroy() -> void:
	print("Destroy spell " + Globals.SpellType.keys()[type])
	queue_free()
