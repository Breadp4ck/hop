extends Item

@onready var body: StaticBody3D = $StaticBody3D

func interact(spell: Spell) -> void:
	animator.play("burn") 
	
func disable_body() -> void:
	body.queue_free()
