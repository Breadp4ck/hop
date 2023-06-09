class_name Shadow
extends Node3D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

@export var needed_types_to_damage: Array[Globals.SpellType] = []

@export var health: int = 1
@export var damage: int = 1
@export var sight_distance: int = 1

@export var wait_time: float = 1.0
@export var walk_time: float = 0.2
@export var hit_time: float = 0.3

var is_dead: bool = false

var state_machine

enum ActivityState {
	CALM,
	ENGAGE
}

var transition_tween: Tween = null
var activity_state: ActivityState = ActivityState.CALM:
	set(value):
		activity_state = value
	get:
		return activity_state
	
var wait_timer: Timer = Timer.new()
var player_visible: bool = false

func _ready() -> void:
	state_machine = animation_tree.get("parameters/playback")
	
	wait_timer.wait_time = wait_time
	wait_timer.autostart = true
	
	add_child(wait_timer)
	wait_timer.timeout.connect(_on_wait_timeout)

func interact_with_spell(spell: Spell) -> void:
	if needed_types_to_damage.has(spell.type) == false:
		return
	
	receive_damage(1)

func receive_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()

func die() -> void:
	sight_distance = 0.0
	activity_state = ActivityState.CALM
	is_dead = true
	state_machine.travel("death")

func destroy() -> void:
	queue_free()

func _on_wait_timeout() -> void:
	if activity_state == ActivityState.ENGAGE:
		var reach_info: Dictionary = get_parent().reach_player(position, sight_distance)
		
		if reach_info["reached"]:
			state_machine.travel("Attack")
			
		elif reach_info["see_player"]:
			var next_step: Vector3 = reach_info["next_step"]
			state_machine.travel("Run")

			look_at(Globals.player_position)
			rotate_y(deg_to_rad(180))
			
			player_visible = true
			var new_position = self.position + next_step
			transition_tween = create_tween()
			transition_tween.tween_property(self, "position", new_position, walk_time)
		else:
			player_visible = false

# Animator
func attack() -> void:
	if get_parent().is_player_near(position) == false:
		return
	
	var player = get_tree().get_first_node_in_group("Player")
	if player != null and player.is_dead == false and World.current_plane == Globals.WorldPlane.COGNITIVE:
		player.receive_damage(damage)
