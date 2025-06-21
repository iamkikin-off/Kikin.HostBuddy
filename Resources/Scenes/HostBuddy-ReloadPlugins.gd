extends Button

func _on_HostBuddyConfig_pressed():
	KikinHostBuddy.load_user_plugins()
	KikinHostBuddy.load_server_config()
	PlayerData._send_notification("Plugins reloaded.", 1)
