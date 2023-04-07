class_name Shadow
extends Node3D

@export var health: int = 1
@export var damage: int = 1
@export var sight_distance: int = 1

@export var wait_time: float = 1.0
@export var walk_time: float = 0.2
@export var hit_time: float = 0.3

enum ActivityState {
	CALM,
	ENGAGE
}

var transition_tween: Tween = null
var activity_state: ActivityState = ActivityState.CALM
var wait_timer: Timer = Timer.new()


func _ready() -> void:
	wait_timer.wait_time = wait_time
	wait_timer.autostart = true
	
	add_child(wait_timer)
	wait_timer.timeout.connect(_on_wait_timeout)


func _on_wait_timeout() -> void:
	if activity_state == ActivityState.ENGAGE:
		var reach_info: Dictionary = get_parent().reach_player(position, sight_distance)
		
		if reach_info["reached"]:
			attack()
			
		elif reach_info["see_player"]:
			var next_step: Vector3 = reach_info["next_step"]
			
			var new_position = self.position + next_step
			transition_tween = create_tween()
			transition_tween.tween_property(self, "position", new_position, walk_time)


func attack() -> void:
	print("ATTACK")
