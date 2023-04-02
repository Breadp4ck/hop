extends Node

# Tile length in meters
const TILE_LENGTH: float = 2.0

# Planes of the World
enum WorldPlane {
	MATERIAL,
	COGNITIVE,
}

const MATERIAL_WORLD_ORIGIN = Vector3.ZERO
const COGNITIVE_WORLD_ORIGIN = Vector3(1000.0, 0.0, 0.0)
