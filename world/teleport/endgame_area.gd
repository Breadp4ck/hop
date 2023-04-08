class_name EndGameArea
extends Node

var enabled: bool = false

func _on_area_entered(area: Area3D) -> void:
	if area.owner is Player and enabled:
		area.owner.is_dead = true
		area.owner.global_position.y += 1000000
		var end_game_screen = get_tree().get_first_node_in_group("EndGameScreen")
		end_game_screen.enable()
