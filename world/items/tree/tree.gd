extends Item

@onready var body: StaticBody3D = $StaticBody3D
@onready var animator: AnimationPlayer = $AnimationPlayer

func interact(spell: Spell) -> void:
	animator.play("C_OldTree") # Norm anim nado.
	body.queue_free() # Remove
	
func disable_body() -> void: # Invoke this at and of animation
	body.queue_free()
