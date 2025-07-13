extends Button

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

var server_request = false

func _on_CreateServerBTN_pressed():
	KikinHostBuddy.module_references["ConfigManager"].server_name = str($"../ServerName/LineEdit".text)
	KikinHostBuddy.module_references["ConfigManager"].server_code = str($"../ServerCode/LineEdit".text)
	KikinHostBuddy.module_references["ConfigManager"].server_size = int($"../ServerSize/LineEdit".text)
	KikinHostBuddy.module_references["ConfigManager"].server_type = int($"../ServerType/LineEdit".text)
	KikinHostBuddy.module_references["ConfigManager"].request = server_request
	KikinHostBuddy.module_references["ConfigManager"].create_lobby()

func _on_Button_pressed():
	server_request = not server_request
	if server_request:
		$"../ServerRequest/Button".text = "Yes"
	else:
		$"../ServerRequest/Button".text = "No"
