extends Button

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

func _on_CreateServer_pressed():
	Network._create_custom_lobby(int(KikinHostBuddy.module_references["ConfigManager"].server_type), int(KikinHostBuddy.module_references["ConfigManager"].server_size), KikinHostBuddy.module_references["ConfigManager"].server_tags, KikinHostBuddy.module_references["ConfigManager"].server_name, KikinHostBuddy.module_references["ConfigManager"].server_request)
	yield(get_tree().create_timer(15.0), "timeout")
	Network._update_chat("Testing", false)
	Network._update_chat("Testing LOCAL", true)
