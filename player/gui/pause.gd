extends Control


func _on_resume_button_pressed() -> void:
	resume_game()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


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
