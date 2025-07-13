extends Control

onready var PluginPanel = preload("res://mods/Kikin.HostBuddy/Resources/Scenes/PluginPanel.tscn")
onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

var server_request = false

func refresh_config_txt():
	var file = File.new()
	var error = file.open(KikinHostBuddy.module_references["ConfigManager"].SERVER_CONFIG_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()
	
	$Config/ConfigJSON.text = str(content)

func _ready():
	server_request = KikinHostBuddy.module_references["ConfigManager"].server_request
	for plugin in KikinHostBuddy.module_references["PluginLoader"].loaded_plugins.keys():
		var newPlugin = PluginPanel.instance()
		newPlugin.get_node("PluginName").text = KikinHostBuddy.module_references["PluginLoader"].loaded_plugins[plugin].plugin_name
		newPlugin.name = KikinHostBuddy.module_references["PluginLoader"].loaded_plugins[plugin].plugin_name
		$Plugins/ScrollContainer/VBoxContainer.add_child(newPlugin)
	
	refresh_config_txt()

func _process(delta):
	$Config/Panel2/ScrollContainer/VBoxContainer/ServerName.placeholder_text = "Server Name: " + str(KikinHostBuddy.module_references["ConfigManager"].server_name)
	$Config/Panel2/ScrollContainer/VBoxContainer/ServerSize.placeholder_text = "Server Size: " + str(KikinHostBuddy.module_references["ConfigManager"].server_size)
	$Config/Panel2/ScrollContainer/VBoxContainer/ServerType.placeholder_text = "TYPE AS TEXT [Public/Unlisted/Private/Offline] | " + str(KikinHostBuddy.module_references["ConfigManager"].server_type)
	$Config/Panel2/ScrollContainer/VBoxContainer/ServerRequest.text = "Server Request: " + str(server_request)
	$Config/Panel2/ScrollContainer/VBoxContainer/ServerTags.placeholder_text = "Server Tags [NOT-EDITABLE IN-GAME]: " + str(KikinHostBuddy.module_references["ConfigManager"].server_tags)

func _on_CloseBTN_pressed():
	$".".visible = false

func _on_ServerRequest_pressed():
	server_request = not server_request
	$Config/Panel2/ScrollContainer/VBoxContainer/ServerRequest.text = "Server Request: " + str(server_request)

func _on_Confirm_pressed():
	KikinHostBuddy.module_references["ConfigManager"].server_name = $Config/Panel2/ScrollContainer/VBoxContainer/ServerName.text
	KikinHostBuddy.module_references["ConfigManager"].server_size = int($Config/Panel2/ScrollContainer/VBoxContainer/ServerSize.text)
	KikinHostBuddy.module_references["ConfigManager"].server_type = $Config/Panel2/ScrollContainer/VBoxContainer/ServerType.text
	KikinHostBuddy.module_references["ConfigManager"].server_request = server_request
	KikinHostBuddy.module_references["ConfigManager"].save_config()
	PlayerData._send_notification("Saved config.")

func _on_Confirm_NewSource_pressed():
	for child in $Plugins/ScrollContainer/VBoxContainer.get_children():
		child.queue_free()
	
	KikinHostBuddy.module_references["PluginLoader"].current_source = $Plugins/YourPluginSource.text
	
	KikinHostBuddy.module_references["PluginLoader"].all_plugins = {}
	KikinHostBuddy.module_references["PluginLoader"].loaded_plugins = {}
	KikinHostBuddy.module_references["PluginLoader"].check_for_plugins()
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	print(KikinHostBuddy.module_references["PluginLoader"].current_source)
	print("LOADED: " + str(KikinHostBuddy.module_references["PluginLoader"].loaded_plugins))
	
	for plugin in KikinHostBuddy.module_references["PluginLoader"].loaded_plugins.keys():
		var newPlugin = PluginPanel.instance()
		newPlugin.get_node("PluginName").text = KikinHostBuddy.module_references["PluginLoader"].loaded_plugins[plugin].plugin_name
		newPlugin.name = KikinHostBuddy.module_references["PluginLoader"].loaded_plugins[plugin].plugin_name
		$Plugins/ScrollContainer/VBoxContainer.add_child(newPlugin)
