extends GridMap

var x_size: int = 20
var z_size: int = 20

func _ready() -> void:
	randomize()
	clear()
	make_map()

func make_map() -> void:
	for x in x_size:
		for z in z_size:
			var cell: int = randi() % 15
			set_cell_item(x, 0, z, cell)
