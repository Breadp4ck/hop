class_name Portal
extends Item

var crystals_needed: int = 4
var crystals_amount: int = 0

func interact(spell: Spell) -> void:
	if (crystals_amount < crystals_needed):
		return
	
	animator.play("Restore")
	interactable = false
	
func disable() -> void: # Invoke this at and of animation
	collision.disabled = true
	body_collision.disabled = true
	
func add_one_crystal():
	crystals_amount += 1
