extends Spatial

const WALL_HEIGHT = 30

func resize_border(tile_size: int, tile_count: int) -> void:
	rpc('make_border', tile_size, tile_count)

sync func make_border(tile_size: int, tile_count: int) -> void:
	var wall_size: int = tile_size * tile_count
	$N_Wall.translation = Vector3(wall_size / 2, WALL_HEIGHT / 2, -1)
	$E_Wall.translation = Vector3(wall_size + 1, WALL_HEIGHT / 2, wall_size / 2)
	$S_Wall.translation = Vector3(wall_size / 2, WALL_HEIGHT / 2, wall_size + 1)
	$W_Wall.translation = Vector3(-1, WALL_HEIGHT / 2, wall_size / 2)

	for child in get_children():
		child.width = wall_size + 2
		child.use_collision = true
