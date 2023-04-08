class_name TeleportSpell
extends Spell

@onready var pit_checker: Node3D = $PitChecker

func _on_area_entered(area) -> void:
	print("Hit " + area.get_name() + " area.")
	end(false)
	
func _on_body_entered(body):
	print("Hit " + body.get_name() + " body.")
	end(false)

func _on_pit_checker_area_entered(area):
	end(false)

func _on_pit_checker_body_entered(body):
	end(false)
	
func start():
	pit_checker.top_level = true
	pit_checker.global_position = destination_position
	print(pit_checker.global_position)
	
func end(successfully: bool = true) -> void:
	if successfully == false:
		destroy()
		return
	print(pit_checker.global_position)
	var player: Player = get_tree().get_nodes_in_group("Player")[0]
	player.global_position = self.global_position
	player.global_position.y -= player.head.position.y
	Sfx.play("teleport")
	destroy()
