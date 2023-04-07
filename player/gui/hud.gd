extends Control

@onready var hp_container: HBoxContainer = $NinePatchRect/MarginContainer/HealthPointContainer
@onready var hp_icon: PackedScene = preload("res://player/gui/health_point_icon.tscn")

@export var health_icon_texture: Texture2D
@export var player: Player

func _ready() -> void:
	player.health_changed.connect(update_hp_count)
	update_hp_count(player.health)

func _on_tree_exited():
	player.health_changed.disconnect(update_hp_count)

func update_hp_count(hp: int) -> void:
	for child in hp_container.get_children():
		child.queue_free()
		
	for idx in range(hp):
		var icon: TextureRect = hp_icon.instantiate()
		hp_container.add_child(icon)
