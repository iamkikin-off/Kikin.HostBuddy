extends Button

func _on_OpenConfig_pressed():
	var file_path = ProjectSettings.globalize_path("user://")
	OS.shell_open(file_path)
