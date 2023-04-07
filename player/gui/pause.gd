extends Control

var player: Player

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.died.connect(on_player_died)

func _on_tree_exiting():
	player.died.disconnect(on_player_died)


func _on_resume_button_pressed() -> void:
	resume_game()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func on_player_died() -> void:
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume_game()
		else:
			stop_game()


func resume_game() -> void:
	self.visible = false
	get_tree().paused = false


func stop_game() -> void:
	self.visible = true
	get_tree().paused = true


