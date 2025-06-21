extends Button

func _on_ReloadPlayerPlugins_pressed():
	KikinHostBuddy.load_user_plugins()
	KikinHostBuddy.load_server_config()
