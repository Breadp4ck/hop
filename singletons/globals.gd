extends Node

# Tile length in meters
const TILE_LENGTH: float = 2.0

# Planes of the World
enum WorldPlane {
	MATERIAL,
	COGNITIVE,
}

enum SpellType{
	FIRE = 0,
	DESTRUCT,
	LOCKPICK,
	REPAIR,
	TIMESTOP,
	TELEPORT,
	EMPTY = -1
}

const WORLD_OFFSET = Vector3(0.0, 100.0, 0.0)

var player_position: Vector3 = Vector3.ZERO
