extends CSGBox

const POSTER_MATERIALS_PATH = 'res://Props/Billboards/BillboardMaterials/'

func _ready() -> void:
	var selected_material = random_material()
	material = load(selected_material)

func random_material() -> Material:
	var material_list = get_files(POSTER_MATERIALS_PATH)
	var selectied_material = material_list[randi() % material_list.size()]
	return selectied_material

func get_files(folderPath: String):
	var gathered_files: Dictionary = {}
	var file_count: int = 0
	var dir: Directory = Directory.new()
	
	dir.open(folderPath)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == '':
			break
		elif not file.begins_with('.'):
			gathered_files[file_count] = folderPath + file
			file_count += 1
	return gathered_files
