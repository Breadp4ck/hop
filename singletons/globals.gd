extends Node

# Tile length in meters
const TILE_LENGTH: float = 2.0

# Planes of the World
enum WorldPlane {
	MATERIAL,
	COGNITIVE,
}

enum SpellType{
	FIRE,
	WATER,
	WIND,
	REPAIR
}

const WORLD_OFFSET = Vector3(0.0, 100.0, 0.0)
