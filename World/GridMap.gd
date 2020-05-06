extends GridMap

const N: int = 1
const E: int = 2
const S: int = 4
const W: int = 8

const spacing: int = 2

const CELL_WALLS = {
	Vector3(0, 0, -spacing): N,
	Vector3(spacing, 0, 0): E,
	Vector3(0, 0, spacing): S,
	Vector3(-spacing, 0, 0): W,
}

const MAX_ROAD_INDEX = 15
const BUILDING_INDICES = {
	0: [17, 18, 19],
	1: [20, 21],
	2: [22, 23, 24],
	3: [25, 26, 27]
}
const BUIDLING_ORIENTATIONS = [0, 10, 16, 22]
const SKYSCRAPER_INDEX = 16
const SKYSCRAPER_CHANCE = 0.025

const erase_percentage: float = 0.25

var x_size: int = 6
var z_size: int = 6

func _ready() -> void:
	clear()	
	if Network.is_server():
		randomize()
		make_map_border()
		make_map()
		record_tile_positions()
		rpc('send_ready')

func is_building(cell_type: int) -> bool:
	return cell_type > MAX_ROAD_INDEX

func record_tile_positions() -> void:
	var tiles = []
	for x in range(0, x_size):
		for z in range(0, z_size):
			var current_cell: Vector3 = Vector3(x, 0, z)
			var current_tile_type: int = get_cell_item(x, 0, z)
			if not is_building(current_tile_type):
				tiles.append(current_cell)
	var map_size: Vector2 = Vector2(x_size, z_size)
	$ObjectSpawner.generate_props(tiles, map_size)

func make_map_border() -> void:
	$Border.resize_border(cell_size.x, x_size)

func make_blank_map() -> void:
	for x in x_size:
		for z in z_size:
			var building_index = choose_building_index(x, z)
			rpc('place_cell', x, 0, z, building_index, BUIDLING_ORIENTATIONS[randi()% BUIDLING_ORIENTATIONS.size()])

func choose_building_index(x_coord: int, z_coord: int) -> int:
	var neighbourhood_index: int = 0
	if x_coord >= x_size / 2:
		neighbourhood_index += 1
	if z_coord >= z_size / 2:
		neighbourhood_index += 2
	var buildings_array = BUILDING_INDICES[neighbourhood_index]

	if randf() < SKYSCRAPER_CHANCE:
		return SKYSCRAPER_INDEX
	else:
		return buildings_array[randi() % buildings_array.size() - 1]

func make_map() -> void:
	make_blank_map()
	make_maze()
	erase_walls()

func erase_walls() -> void:
	for i in range(int(x_size * z_size * erase_percentage)):
		var x: int = int(rand_range(1, (x_size - 1) / spacing)) * spacing
		var z: int = int(rand_range(1, (z_size - 1) / spacing)) * spacing
		var cell: Vector3 = Vector3(x, 0, z)
		var current_cell: int = get_cell_item(cell.x, cell.y, cell.z)
		var neighbour: Vector3 = CELL_WALLS.keys()[randi() % CELL_WALLS.size()]
		
		if current_cell & CELL_WALLS[neighbour]:
			var walls: int = clamp(current_cell - CELL_WALLS[neighbour], 0, MAX_ROAD_INDEX)
			var neighbour_walls: int = clamp(get_cell_item(
				cell.x + neighbour.x,
				cell.y + neighbour.y,
				cell.z + neighbour.z
			) - CELL_WALLS[-neighbour], 0, MAX_ROAD_INDEX)
			rpc('place_cell', cell.x, 0, cell.z, walls, 0)
			rpc('place_cell', cell.x + neighbour.x, 0, cell.z + neighbour.z, neighbour_walls, 0)
			fill_gaps(cell, neighbour)

func make_maze() -> void:
	var unvisited = []
	var stack = []
	
	for x in range(0, x_size, spacing):
		for z in range(0, z_size, spacing):
			unvisited.append(Vector3(x, 0, z))
	
	var current: Vector3 = Vector3.ZERO
	unvisited.erase(current)
	
	while unvisited:
		var neighbours = get_unvisited_neighbours(current, unvisited)
		if neighbours.size() > 0:
			var next: Vector3
			if current == Vector3.ZERO:
				next = Vector3(0, 0, spacing)
			else:
				next = neighbours[randi() % neighbours.size()]

			stack.append(current)
			var direction: Vector3 = next - current

			var current_walls = min(get_cell_item(current.x, 0, current.z), MAX_ROAD_INDEX) - CELL_WALLS[direction]
			var next_walls = min(get_cell_item(next.x, 0, next.z), MAX_ROAD_INDEX) -CELL_WALLS[-direction]

			rpc('place_cell', current.x, 0, current.z, current_walls, 0)
			rpc('place_cell', next.x, 0, next.z, next_walls, 0)
			fill_gaps(current, direction)

			current = next
			unvisited.erase(current)
		elif stack.size() > 0:
			current = stack.pop_back()

func fill_gaps(current: Vector3, direction: Vector3) -> void:
	var tile_type: int
	
	for i in range(1, spacing):
		if direction.x != 0:
			tile_type = 5
			current.x += sign(direction.x)
		if direction.z != 0:
			tile_type = 10
			current.z += sign(direction.z)
		rpc('place_cell', current.x, 0, current.z, tile_type, 0)
	
func get_unvisited_neighbours(cell_location: Vector3, unvisited_cells):
	var unvisited_neighbours = []
	for cardinal_direction in CELL_WALLS.keys():
		if cell_location + cardinal_direction in unvisited_cells:
			unvisited_neighbours.append(cell_location + cardinal_direction)
	return unvisited_neighbours

sync func place_cell(x, y, z, cell, orientation) -> void:
	set_cell_item(x, y, z, cell, orientation)

sync func send_ready() -> void:
	if Network.is_server():
		player_ready()
	else:
		rpc_id(1, 'player_ready')

remote func player_ready() -> void:
	Network.players_ready += 1
	if Network.players_ready == Network.players.size():
		rpc('send_go')

sync func send_go() -> void:
	get_tree().call_group('GameState', 'unpause')
