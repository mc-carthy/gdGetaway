extends Node

const DEFAULT_IP: String = '127.0.0.1'
const DEFAULT_PORT: int = 32023
const MAX_PLAYERS: int = 4

var local_player_id: int = 0

signal player_disconnected
signal server_disconnected

func _ready() -> void:
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')

func create_server() -> void:
	var peer: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	local_player_id = get_local_player_id()
	print('Server created')
	print('PlayerID: ' + str(local_player_id))

func connect_to_server() -> void:
	var peer: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	peer.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	local_player_id = get_local_player_id()
	
func get_local_player_id() -> int:
	return get_tree().get_network_unique_id()

func _connected_to_server() -> void:
	rpc('_send_player_info', local_player_id)

func _is_server() -> bool:
	#return local_player_id == 1
	return get_tree().is_network_server()

func _send_player_info(id: int) -> void:
	if _is_server():
		print(str(id) + ' has connected.')

func _on_player_connected(id: int):
	if not _is_server():
		print(str(id) + ' has connected.')
