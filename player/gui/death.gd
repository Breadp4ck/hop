extends Node

var player: Player

signal inputed()

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.died.connect(on_player_died)

func _input(event):
	inputed.emit()

func _on_tree_exiting():
	player.died.disconnect(on_player_died)
	
func on_player_died() -> void:
	self.visible = true
	Sfx.stop()
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()
