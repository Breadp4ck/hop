class_name Player
extends Node3D

signal health_changed(hp: int)
signal died()

const INTERACT_RAY_LENGTH: float = 3.0

@export var health: int = 3 # amount
@export var rotation_time: float = 0.25 # sec
@export var walk_time: float = 0.35 # sec
@export var max_queue_transitions: int = 1 # amount
@export var jump_check_area: Area3D
@export var spell_caster: SpellCaster

@onready var eye: Camera3D = $Head/Eye
@onready var head: Node3D = $Head
@onready var body: Node3D = $Body
@onready var obstacle_ray: RayCast3D = $Body/ObstacleDetectionRay
@onready var animator: AnimationPlayer = $Head/Eye/AnimationPlayer
@onready var effects: AnimationPlayer = $Head/Eye/EffectsPlayer

@onready var material_env: Environment = load("res://player/material_env.tres")
@onready var shadesmar_env: Environment = load("res://player/shadesmar_env.tres")
@onready var gui: GUI = $GUI

@onready var hand_ring: Node3D = $Body/hand_with_ring
@onready var hand: Node3D = $Body/hand_without_ring

var can_input: bool = true:
	get:
		return (not is_jumping) and (transition_tween == null or not transition_tween.is_running()) and (not is_spell_delay) and (not is_dead)

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

var last_transition: Movement = -1
var is_jumping: bool = false
var is_dead: bool = false
var is_spell_delay: bool = false
var spell_delay_time: float = 0.5

var transition_queue: Array = []

func _ready():
	Globals.player_position = global_position

func _input(event: InputEvent) -> void:
	if can_input == false:
		return

	if event.is_action_pressed("cast_spell"):
		if spell_caster.try_cast_choosen():
			Sfx.play("spell")
			activate_spell_delay()

	if event.is_action_pressed("cancel_spell"):
		spell_caster.cancel_choose()

	if event.is_action_pressed("interact"):
		interact_ray_origin = eye.project_ray_origin(event.position)
		interact_ray_normal = interact_ray_origin + eye.project_ray_normal(event.position) * INTERACT_RAY_LENGTH
		want_interact = true

	if event.is_action_pressed("jump_to_plane"):
		var inventory_item_types: Array = []
		for i in Inventory.items.size():
			inventory_item_types.push_back(Inventory.items[i].type)
		if inventory_item_types.has(InventoryItem.Type.RING):
			effects.play("hop")

	var transition = get_pressed_movement_transition()
	if transition == -1:
		return
	if transition == Movement.ROTATE_LEFT or transition == Movement.ROTATE_RIGHT:
		if last_transition == Movement.ROTATE_LEFT or last_transition == Movement.ROTATE_RIGHT:
			return

	add_transition(transition)

func _process(delta: float) -> void:
	if want_interact:
		interact()
	
	if not transition_queue.is_empty() and (transition_tween == null or not transition_tween.is_running()):
		apply_transition(transition_queue.pop_front())

# Movement functions
# --------------------------------------------------------------------------------------------------

func add_transition(transition: Movement) -> void:
	if transition_queue.size() >= max_queue_transitions or is_jumping:
		return
	
	if transition == Movement.ROTATE_LEFT or transition == Movement.ROTATE_RIGHT:
		transition_queue.push_back(transition)
	elif transition_tween == null or not transition_tween.is_running():
		transition_queue.push_back(transition)

func apply_transition(transition: Movement) -> void:
	var along: Vector3

	last_transition = transition

	match transition:
		Movement.ROTATE_LEFT:
			smooth_rotate(90.0)
			return
		Movement.ROTATE_RIGHT:
			smooth_rotate(-90.0)
			return
		Movement.MOVE_FORWARD:
			along = Vector3.FORWARD
		Movement.MOVE_BACK:
			along = Vector3.BACK
		Movement.MOVE_LEFT:
			along = Vector3.LEFT
		Movement.MOVE_RIGHT:
			along = Vector3.RIGHT
		_: 
			return

	if is_transition_possible(along):
		smooth_walk(head.global_transform.basis * along)

func get_pressed_movement_transition() -> Movement:
	var rotate_axis := Input.get_axis("rotate_left", "rotate_right")
	var forward_axis := Input.get_axis("move_back", "move_forward")
	var side_axis := Input.get_axis("move_left", "move_right")
	
	if rotate_axis > 0:
		return Movement.ROTATE_RIGHT
	elif rotate_axis < 0:
		return Movement.ROTATE_LEFT
	
	elif forward_axis > 0:
		return Movement.MOVE_FORWARD
	elif forward_axis < 0:
		return Movement.MOVE_BACK
		
	elif side_axis > 0:
		return Movement.MOVE_RIGHT
	elif side_axis < 0:
		return Movement.MOVE_LEFT
		
	return -1

func is_transition_possible(along: Vector3) -> bool:
	obstacle_ray.target_position = along * Globals.TILE_LENGTH
	obstacle_ray.force_raycast_update()
	return obstacle_ray.get_collider() == null

func on_tween_transition_finished():
	Globals.player_position = global_position
	
	animator.speed_scale = 1
	transition_tween.finished.disconnect(on_tween_transition_finished)
	var transition = get_pressed_movement_transition()
	add_transition(transition)

func smooth_walk(direction: Vector3) -> void:
	transition_tween = create_tween()
	var new_position = self.global_position + direction * Globals.TILE_LENGTH
	transition_tween.tween_property(self, "global_position", new_position, walk_time)
	animator.speed_scale = 1 / walk_time
	animator.play("Walk")
	transition_tween.finished.connect(on_tween_transition_finished)

func smooth_rotate(angle: float) -> void:
	transition_tween = create_tween()
	var new_rotation = self.global_rotation.y + deg_to_rad(angle)
	transition_tween.tween_property(self, "global_rotation:y", new_rotation, rotation_time)
	transition_tween.finished.connect(on_tween_transition_finished)

func set_is_jumping(value: bool) -> void:
	is_jumping = value

# Animator.
func jump_to_plane() -> void:
	jump_check_area.global_position = head.global_position

	if not can_jump_to_plane():
		animator.stop()
		return
	
	Sfx.play("hop")

	match World.current_plane:
		Globals.WorldPlane.MATERIAL:
			global_position += Globals.WORLD_OFFSET
			eye.environment = shadesmar_env
		Globals.WorldPlane.COGNITIVE:
			global_position -= Globals.WORLD_OFFSET
			eye.environment = material_env
	
	World.invert_plane()
	spell_caster.cancel_choose()
	Globals.player_position = global_position

func can_jump_to_plane() -> bool:
	if jump_check_area.has_overlapping_bodies():
		print(jump_check_area.get_overlapping_bodies())
		print("Cant hop")
		jump_check_area.global_position = head.global_position
		return false
	
	if transition_tween == null or not transition_tween.is_running():
		return true
		
	return false

# Animator.
func move_jump_check_area() -> void:
	match World.current_plane:
		Globals.WorldPlane.MATERIAL:
			jump_check_area.position += Globals.WORLD_OFFSET
		Globals.WorldPlane.COGNITIVE:
			jump_check_area.position -= Globals.WORLD_OFFSET

# HP functions
# --------------------------------------------------------------------------------------------------

func receive_damage(amount: int) -> void:
	health -= amount
	health_changed.emit(health)
	if (health <= 0):
		die()
	
	print("Player damaged by " + str(amount))

func die():
	Inventory.items.clear()
	World.current_plane = Globals.WorldPlane.MATERIAL
	global_position.y += 1000000
	died.emit()
	is_dead = true
	#queue_free()

# Interaction functions
# --------------------------------------------------------------------------------------------------

func interact() -> void:
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		interact_ray_origin,
		interact_ray_normal,
	)
	
	query.collide_with_areas = true
	query.collision_mask = 1
	
	var intersection := space_state.intersect_ray(query)
	
	if intersection.has("collider") and intersection.collider is Item and intersection.collider.interactable:
		intersection.collider.interacted.emit(null)
		print("hit some shit")
		
		if intersection.collider is InventoryItem:
			if intersection.collider.type == InventoryItem.Type.BOOK:
				gui.toggle_book()
			elif intersection.collider.type == InventoryItem.Type.RING:
				hand.visible = false
				hand_ring.visible = true
		
	want_interact = false

func activate_spell_delay() -> void:
	is_spell_delay = true
	await get_tree().create_timer(spell_delay_time).timeout
	is_spell_delay = false
