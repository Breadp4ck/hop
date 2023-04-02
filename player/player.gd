extends Node3D

const INTERACT_RAY_LENGTH: float = 3.0

@export var rotation_time: float = 0.2 # sec
@export var walk_time: float = 0.2 # sec
@export var max_queue_transitions: int = 2 # sec

@onready var eye: Camera3D = $Head/Eye

enum Movement {
	ROTATE_LEFT,
	ROTATE_RIGHT,
	MOVE_FORWARD,
	MOVE_BACK,
	MOVE_LEFT,
	MOVE_RIGHT,
}

var want_interact: bool = false
var interact_ray_origin: Vector3 = Vector3.ZERO
var interact_ray_normal: Vector3 = Vector3.FORWARD
var transition_tween: Tween

var transition_queue: Array = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact_ray_origin = eye.project_ray_origin(event.position)
		interact_ray_normal = interact_ray_origin + eye.project_ray_normal(event.position)
		want_interact = true
#
	if event.is_action_pressed("rotate_left"):
		add_transition(Movement.ROTATE_LEFT)
	elif event.is_action_pressed("rotate_right"):
		add_transition(Movement.ROTATE_RIGHT)
	
	if event.is_action_pressed("move_forward"):
		add_transition(Movement.MOVE_FORWARD)
	elif event.is_action_pressed("move_back"):
		add_transition(Movement.MOVE_BACK)
	elif event.is_action_pressed("move_left"):
		add_transition(Movement.MOVE_LEFT)
	elif event.is_action_pressed("move_right"):
		add_transition(Movement.MOVE_RIGHT)


func _physics_process(delta: float) -> void:
	if want_interact:
		interact()
	
	if not transition_queue.is_empty() and (transition_tween == null or not transition_tween.is_running()):
		apply_transition(transition_queue.pop_front())


# Movement functions
# --------------------------------------------------------------------------------------------------

func add_transition(transition: Movement) -> void:
	if transition_queue.size() < max_queue_transitions:
		transition_queue.push_back(transition)

func apply_transition(transition: Movement) -> void:
	match transition:
		Movement.ROTATE_LEFT:
			smooth_rotate(90.0)
		Movement.ROTATE_RIGHT:
			smooth_rotate(-90.0)
		Movement.MOVE_FORWARD:
			smooth_walk(eye.global_transform.basis * Vector3.FORWARD)
		Movement.MOVE_BACK:
			smooth_walk(eye.global_transform.basis * Vector3.BACK)
		Movement.MOVE_LEFT:
			smooth_walk(eye.global_transform.basis * Vector3.LEFT)
		Movement.MOVE_RIGHT:
			smooth_walk(eye.global_transform.basis * Vector3.RIGHT)

func smooth_walk(direction: Vector3) -> void:
	transition_tween = create_tween()
	var new_position = self.global_position + direction * Globals.TILE_LENGTH
	transition_tween.tween_property(self, "global_position", new_position, walk_time)

func smooth_rotate(angle: float) -> void:
	transition_tween = create_tween()
	var new_rotation = self.global_rotation.y + deg_to_rad(angle)
	transition_tween.tween_property(self, "global_rotation:y", new_rotation, rotation_time)


# Interaction functions
# --------------------------------------------------------------------------------------------------

func interact() -> void:
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		interact_ray_origin,
		interact_ray_normal * INTERACT_RAY_LENGTH
	)
	
	var intersection := space_state.intersect_ray(query)
	if intersection != null and intersection.collider is Item:
		intersection.collider.interacted.emit(false)
	
	want_interact = false
