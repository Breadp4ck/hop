extends Node3D

@onready var astar_grid: AStarGrid2D = AStarGrid2D.new()

@export var walls_grid: GridMap
@export var grid_size: Vector2i

var is_player_visible: bool = false
var local_player_position: Vector2i = Vector2i.ZERO

func _ready() -> void:
	if walls_grid == null:
		push_error("Add GridMap as child with name ShadowWalkGrid")
		return
	
	astar_grid = AStarGrid2D.new()
	astar_grid.diagonal_mode =AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.size = grid_size
	
	astar_grid.update()
	
	for wall in walls_grid.get_used_cells():
		var tile: Vector2i = Vector2i(wall.x + grid_size.x / 2, wall.z + grid_size.y / 2)
		astar_grid.set_point_solid(tile)


func update_player_position() -> void:
	var player_position: Vector3 = Globals.player_position - self.global_position
	
	local_player_position = Vector2i(
		int(round(player_position.x / Globals.TILE_LENGTH)) + grid_size.x / 2,
		int(round(player_position.z / Globals.TILE_LENGTH)) + grid_size.y / 2
	)
	
	if World.current_plane == Globals.WorldPlane.COGNITIVE and is_player_reachable(local_player_position):
		is_player_visible = true
	else:
		is_player_visible = false


func is_player_reachable(local_player_position: Vector2i) -> bool:
	return astar_grid.get_id_path(Vector2i.ZERO, local_player_position) == []


func is_player_near(shadow_position: Vector3) -> bool:
	update_player_position()
	var local_shadow_position := _shadow_position_to_grid_coords(shadow_position)
	return astar_grid.get_id_path(local_shadow_position, local_player_position).size() <= 2


func _shadow_position_to_grid_coords(shadow_position: Vector3) -> Vector2i:
	var grid_shadow_position := Vector2i(
		int(round(shadow_position.x / Globals.TILE_LENGTH)) + grid_size.x / 2,
		int(round(shadow_position.z / Globals.TILE_LENGTH)) + grid_size.y / 2
	)
	
	return grid_shadow_position


# Local shadow position
func reach_player(from: Vector3, sight_distance: int) -> Dictionary:
	var local_shadow_position := _shadow_position_to_grid_coords(from)
	var path := astar_grid.get_id_path(local_shadow_position, local_player_position)
	
	if path.size() < 2:
		return {
			"next_step": Vector2i.ZERO,
			"see_player": false,
			"reached": false
		}
	
	var shadow_offset := Vector3(
		path[1].x - local_shadow_position.x,
		0.0,
		path[1].y - local_shadow_position.y
	)
	
	return {
		"next_step": shadow_offset * Globals.TILE_LENGTH,
		"see_player": path.size() < sight_distance + 2,
		"reached": path.size() == 2
	}


func attack_player() -> void:
	for child in get_children():
		if child is Shadow and !child.is_dead:
			child.activity_state = Shadow.ActivityState.ENGAGE


func calm_down() -> void:
	for child in get_children():
		if child is Shadow:
			child.activity_state = Shadow.ActivityState.CALM


func _on_timer_timeout() -> void:
	update_player_position()
	
	if is_player_visible:
		attack_player()
	else:
		calm_down()
