extends Button

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

func _on_ReloadConfig_pressed():
	KikinHostBuddy.module_references["ConfigManager"].load_server_config()
