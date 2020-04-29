extends Spatial

func _ready() -> void:
	spawn_local_player()
	rpc('spawn_remote_player', Network.local_player_id)

func spawn_local_player() -> void:
	# TODO: Make player class name to enable auto-complete
	# TODO: Use scene path instead of string ref
	var new_player = preload('res://Player/Player.tscn').instance()
	new_player.name = str(Network.local_player_id)
	new_player.translation = Vector3(16, 2.5, 14)
	$Players.add_child(new_player)

remote func spawn_remote_player(id: int) -> void:
	var new_player = preload('res://Player/Player.tscn').instance()
	new_player.name = str(id)
	new_player.translation = Vector3(16, 2.5, 14)
	$Players.add_child(new_player)
