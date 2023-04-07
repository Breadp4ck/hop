class_name TeleportSpell
extends Spell

func _on_area_entered(area) -> void:
	print("Hit " + area.get_name() + " area.")
	end(false)
	
func _on_body_entered(body):
	print("Hit " + body.get_name() + " body.")
	end(false)
	
func end(successfully: bool = true) -> void:
	if successfully == false:
		destroy()
		return
	
	var player: Player = get_tree().get_nodes_in_group("Player")[0]
	player.global_position = self.global_position
	player.global_position.y -= player.head.position.y
	destroy()
