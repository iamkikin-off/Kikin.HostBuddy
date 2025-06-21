extends Control

func _process(delta):
	$Background/ServerName.text = "Server Name: " + str(KikinHostBuddy.server_name)
	$Background/ServerSize.text = "Server Size: " + str(KikinHostBuddy.server_size)
	$Background/ServerType.text = "Server Type: " + str(KikinHostBuddy.server_type)
	$Background/ServerRequest.text = "Server Request: " + str(KikinHostBuddy.server_request)
	$Background/ServerTags.text = "Server Tags: " + str(KikinHostBuddy.server_tags)
	$Background/ServerPlugins.text = "Server Plugins: " + str(KikinHostBuddy.plugins)
	$Background/ServerPluginSettings.text = "Server Plugin Settings: " + str(KikinHostBuddy.plugin_settings)

func _on_CloseBTN_pressed():
	$".".visible = false
