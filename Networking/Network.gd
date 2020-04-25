#TODO: Remove ip & port variables and have them passed in from lobby
extends Node

const DEFAULT_IP: String = '127.0.0.1'
const DEFAULT_PORT: int = 32023
const MAX_PLAYERS: int = 4

var selected_ip: String
var selected_port: int

var local_player_id: int = 0
sync var players: Dictionary = {}
sync var local_player_data: Dictionary = {}

signal player_disconnected
signal server_disconnected

func _ready() -> void:
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')

func create_server() -> void:
	var peer: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	peer.create_server(selected_port, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	add_to_player_list()

func connect_to_server() -> void:
	var peer: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	peer.create_client(selected_ip, selected_port)
	get_tree().set_network_peer(peer)

	
func add_to_player_list() -> void:
	local_player_id = get_tree().get_network_unique_id()
	local_player_data = SaveGame.save_data
	players[local_player_id] = local_player_data

func _connected_to_server() -> void:
	add_to_player_list()
	rpc('_send_player_info', local_player_id, local_player_data)

func _is_server() -> bool:
	#return local_player_id == 1
	return get_tree().is_network_server()

remote func _send_player_info(id: int, player_data: Dictionary) -> void:
	players[id] = player_data
	if _is_server():
		rset('players', players)
		rpc('update_waiting_room')

func _on_player_connected(id: int):
	if not _is_server():
		print(str(id) + ' has connected.')
		

sync func update_waiting_room():
	get_tree().call_group('waiting_room', 'refresh_players', players)
