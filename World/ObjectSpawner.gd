extends Node

const TILE_SIZE = 20

onready var gridmap: GridMap = get_node('..')

var tiles = []
var map_size: Vector2 = Vector2.ZERO

var number_of_parked_cars = 10
var number_of_billboards = 10
var number_of_traffic_cones = 10
var number_of_hydrants = 10
var number_of_lights = 10
var number_of_dumpsters = 5
var number_of_scaffolds = 5

func generate_props(tile_list, size: Vector2) -> void:
	tiles = tile_list
	size = map_size
	place_cars()
	place_billboards()
	place_traffic_cones()
	place_hydrants()
	place_lights()
	place_scaffolds()

func place_cars() -> void:
	var tile_list = random_tile(number_of_parked_cars + number_of_dumpsters)
	for i in range(number_of_parked_cars):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_car', tile, tile_rotation)
	place_dumpsters(tile_list)

sync func spawn_car(tile: Vector3, rotation: int) -> void:
	var car = preload('res://Props/ParkedCars.tscn').instance()
	car.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	car.rotation_degrees.y = rotation
	add_child(car, true)

func place_dumpsters(tile_list) -> void:
	for i in range(number_of_dumpsters):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_dumpster', tile, tile_rotation)

sync func spawn_dumpster(tile: Vector3, rotation: int) -> void:
	var dumpster = preload('res://Props/Dumpster/Dumpster.tscn').instance()
	dumpster.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	dumpster.rotation_degrees.y = rotation
	add_child(dumpster, true)

func place_scaffolds() -> void:
	var tile_list = random_tile(number_of_scaffolds)
	for i in range(number_of_scaffolds):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_scaffold', tile, tile_rotation)

sync func spawn_scaffold(tile: Vector3, rotation: int) -> void:
	var scaffold = preload('res://Props/Scaffold/Scaffold.tscn').instance()
	scaffold.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	scaffold.rotation_degrees.y = rotation
	add_child(scaffold, true)

func place_lights() -> void:
	var tile_list = random_tile(number_of_lights)
	for i in range(number_of_lights):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_light', tile, tile_rotation)

sync func spawn_light(tile: Vector3, rotation: int) -> void:
	var light = preload('res://Props/StreetLamp/StreetLamp.tscn').instance()
	light.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	light.rotation_degrees.y = rotation
	add_child(light, true)

func place_hydrants() -> void:
	var tile_list = random_tile(number_of_hydrants)
	for i in range(number_of_hydrants):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_hydrant', tile, tile_rotation)

sync func spawn_hydrant(tile: Vector3, rotation: int) -> void:
	var hydrant = preload('res://Props/Hydrant/Hydrant.tscn').instance()
	hydrant.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	hydrant.rotation_degrees.y = rotation
	add_child(hydrant, true)

func place_traffic_cones() -> void:
	var tile_list = random_tile(number_of_traffic_cones)
	for i in range(number_of_traffic_cones):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_traffic_cones', tile, tile_rotation)

sync func spawn_traffic_cones(tile: Vector3, rotation: int) -> void:
	var traffic_cones = preload('res://Props/TrafficCones/TrafficCones.tscn').instance()
	traffic_cones.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	traffic_cones.rotation_degrees.y = rotation
	add_child(traffic_cones, true)

func place_billboards() -> void:
	var tile_list = random_tile(number_of_billboards)
	for i in range(number_of_billboards):
		var tile = tile_list.pop_front()
		var tile_type = gridmap.get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotationLookup.lookup_tile_rotation(tile_type)
		if allowed_rotations:
			var tile_rotation: int = allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y += 0.5
			rpc('spawn_billboard', tile, tile_rotation)

sync func spawn_billboard(tile: Vector3, rotation: int) -> void:
	var billboard = preload('res://Props/Billboards/Billboard.tscn').instance()
	billboard.translation = Vector3(tile.x * TILE_SIZE + TILE_SIZE / 2, tile.y, tile.z * TILE_SIZE + TILE_SIZE / 2)
	billboard.rotation_degrees.y = rotation
	add_child(billboard, true)

func random_tile(tile_count: int):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile: Vector3 = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles
