class_name Door
extends Item

@onready var body: StaticBody3D = $StaticBody3D

func interact(spell: Spell) -> void:
	animator.play("Open")
	disable_body() # Remove
	interactable = false
	
func disable_body() -> void: # Invoke this at and of animation
	body.queue_free()
