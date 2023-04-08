class_name Portal
extends Item

@onready var end_game_area: EndGameArea = $EndGameArea

var crystals_needed: int = 4
var crystals_amount: int = 0

func interact(spell: Spell) -> void:
	if (crystals_amount < crystals_needed):
		return
	
	animator.play("Restore")
	interactable = false
	end_game_area.enabled = true
	
func disable() -> void: # Invoke this at and of animation
	collision.disabled = true
	body_collision.disabled = true
	
func add_one_crystal():
	crystals_amount += 1
