extends Control

onready var nameTextBox: Node = $VBoxContainer/CenterContainer/GridContainer/NameTextBox

func _ready() -> void:
	nameTextBox.text = SaveGame.save_data['player_name']

func _on_HostButton_pressed() -> void:
	Network.create_server()
	create_waiting_room()

func _on_JoinButton_pressed() -> void:
	Network.connect_to_server()
	create_waiting_room()


func _on_NameTextBox_text_changed(new_text: String) -> void:
	SaveGame.save_data['player_name'] = nameTextBox.text
	SaveGame.save_game()

func create_waiting_room() -> void:
	$WaitingRoom.popup_centered()
	$WaitingRoom.refresh_players(Network.players)
