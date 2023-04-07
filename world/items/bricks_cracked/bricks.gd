extends Item

@onready var anim: AnimationPlayer = $AnimationPlayer

func interact(spell: Spell) -> void:
	anim.play("cracked")
	interactable = false
	
func disable() -> void:
	collision.disabled = true
	body_collision.disabled = true
	queue_free()
