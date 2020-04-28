extends Control

onready var nameTextBox: Node = $VBoxContainer/CenterContainer/GridContainer/NameTextBox
onready var ipTextBox: Node = $VBoxContainer/CenterContainer/GridContainer/IPTextBox
onready var portTextBox: Node = $VBoxContainer/CenterContainer/GridContainer/PortTextBox

func _ready() -> void:
	nameTextBox.text = SaveGame.save_data['player_name']
	ipTextBox.text = Network.DEFAULT_IP
	portTextBox.text = str(Network.DEFAULT_PORT)

func _on_HostButton_pressed() -> void:
	Network.selected_port = int(portTextBox.text)
	Network.create_server()
	get_tree().call_group('HostOnly', 'show')
	create_waiting_room()

func _on_JoinButton_pressed() -> void:
	Network.selected_ip = ipTextBox.text
	Network.selected_port = int(portTextBox.text)
	Network.connect_to_server()
	create_waiting_room()


func _on_NameTextBox_text_changed(new_text: String) -> void:
	SaveGame.save_data['player_name'] = nameTextBox.text
	SaveGame.save_game()

func create_waiting_room() -> void:
	$WaitingRoom.popup_centered()
	$WaitingRoom.refresh_players(Network.players)


func _on_ReadyButton_pressed() -> void:
	Network.start_game()
