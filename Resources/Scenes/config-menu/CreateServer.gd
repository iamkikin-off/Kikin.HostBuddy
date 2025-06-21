extends Button

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

func _on_CreateServer_pressed():
	Network._create_custom_lobby(int(KikinHostBuddy.server_type), int(KikinHostBuddy.server_size), KikinHostBuddy.server_tags, KikinHostBuddy.server_name, KikinHostBuddy.server_request)
	yield(get_tree().create_timer(15.0), "timeout")
	Network._update_chat("Testing", false)
	Network._update_chat("Testing LOCAL", true)
