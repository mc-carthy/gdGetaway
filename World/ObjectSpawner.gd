extends Node

const TILE_SIZE = 20

var tiles = []
var map_size: Vector2 = Vector2.ZERO
var number_of_parked_cars = 10
onready var gridmap: GridMap = get_node('..')

func generate_props(tile_list, size: Vector2) -> void:
	tiles = tile_list
	size = map_size
	place_cars()

func place_cars() -> void:
	var tile_list = random_tile(number_of_parked_cars)
	for i in range(number_of_parked_cars):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		print(tile_type)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		print(allowed_rotations)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_car', tile, tile_rotation)

sync func spawn_car(tile: Vector3, rotation: int) -> void:
	print('Spawning car')
	var car = preload('res://Props/ParkedCars.tscn').instance()
	car.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	car.rotation_degrees.y = rotation
	add_child(car, true)

func random_tile(tile_count: int):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile: Vector3 = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles
