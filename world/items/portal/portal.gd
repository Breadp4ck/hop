extends Item

@onready var body: StaticBody3D = $StaticBody3D
@onready var animator: AnimationPlayer = $AnimationPlayer

func interact(spell: Spell) -> void:
	animator.play("Restore") # Norm anim nado.
	disable_body() # Remove
	interactable = false
	
func disable_body() -> void: # Invoke this at and of animation
	body.queue_free()
