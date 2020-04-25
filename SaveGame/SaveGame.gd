extends Node

const SAVE_LOCATION: String = "user://SaveData.json"

var save_data: Dictionary = {}

func _ready() -> void:
	save_data = get_data()

func get_data() -> Dictionary:
	var file: File = File.new()
	if not file.file_exists(SAVE_LOCATION):
		save_data = { 'player_name': 'unnamed' }
		save_game()
	file.open(SAVE_LOCATION, File.READ)
	var content: String = file.get_as_text()
	var data: Dictionary = parse_json(content)
	save_data = data
	file.close()
	return data

func save_game() -> void:
	var save_game_file = File.new()
	save_game_file.open(SAVE_LOCATION, File.WRITE)
	save_game_file.store_line(to_json(save_data))
