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

var x_size: int = 20
var z_size: int = 20

func _ready() -> void:
	randomize()
	clear()
	make_map()

func make_blank_map() -> void:
	for x in x_size:
		for z in z_size:
			set_cell_item(x, 0, z, 15)

func make_map() -> void:
	make_blank_map()
	make_maze()

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
			stack.append(current)
			
			var next: Vector3 = neighbours[randi() % neighbours.size()]
			var direction: Vector3 = next - current
			
			var current_walls = get_cell_item(current.x, 0, current.z) - CELL_WALLS[direction]
			var next_walls = get_cell_item(next.x, 0, next.z) -CELL_WALLS[-direction]
			
			set_cell_item(current.x, 0, current.z, current_walls, 0)
			set_cell_item(next.x, 0, next.z, next_walls, 0)
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
		set_cell_item(current.x, 0, current.z, tile_type, 0)
	
func get_unvisited_neighbours(cell_location: Vector3, unvisited_cells):
	var unvisited_neighbours = []
	for cardinal_direction in CELL_WALLS.keys():
		if cell_location + cardinal_direction in unvisited_cells:
			unvisited_neighbours.append(cell_location + cardinal_direction)
	return unvisited_neighbours
