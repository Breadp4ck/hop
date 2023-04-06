class_name Spell
extends Node

@export var type: Globals.SpellType
@export var length: float = 3.0
@export var duration: float = 1.0

var transition_tween: Tween

func move(direction: Vector3) -> void:
	transition_tween = create_tween()
	var new_position = self.global_position + direction * length * Globals.TILE_LENGTH
	transition_tween.tween_property(self, "global_position", new_position, duration)
	transition_tween.finished.connect(on_tween_transition_finished)

func on_tween_transition_finished() -> void:
	transition_tween.finished.disconnect(on_tween_transition_finished)
	queue_free()

func _on_area_entered(area) -> void:
	if area is Item and area.interactable:
		area.interacted.emit(self)
		
	queue_free()
