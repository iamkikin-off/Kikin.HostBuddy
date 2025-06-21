extends Button

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

var server_request = false

func _on_CreateServerBTN_pressed():
	KikinHostBuddy.server_name = str($"../ServerName/LineEdit".text)
	KikinHostBuddy.server_code = str($"../ServerCode/LineEdit".text)
	KikinHostBuddy.server_size = int($"../ServerSize/LineEdit".text)
	KikinHostBuddy.server_type = int($"../ServerType/LineEdit".text)
	KikinHostBuddy.request = server_request
	KikinHostBuddy.create_lobby()

func _on_Button_pressed():
	server_request = not server_request
	if server_request:
		$"../ServerRequest/Button".text = "Yes"
	else:
		$"../ServerRequest/Button".text = "No"
