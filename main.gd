extends Node

# this is just for the main menu and esc menu so don't mind this
const HostBuddy_Button := preload("res://mods/Kikin.HostBuddy/Resources/Scenes/HostBuddy-config.tscn")
const HostBuddy_Reload := preload("res://mods/Kikin.HostBuddy/Resources/Scenes/HostBuddy-ReloadPlugins.tscn")
const HostBuddy_Menu := preload("res://mods/Kikin.HostBuddy/Resources/Scenes/config-menu/HostBuddy-menu.tscn")

# Directories
const SERVER_CONFIG_PATH = "user://hostbuddy_server_config.json"
const PLUGIN_DIR := "user://HB_Plugins"

# Just the info for this mod
const VERSION = "v1.0"
const PREFIX = "[HostBuddy/" + VERSION + "] "

# Player API duh
var PlayerAPI

# Server variables.
var server_name = ""
var server_size = 0
var server_type = 0
var server_tags = []
var server_request = false
var plugins = []
var plugin_settings = {}

# List 
var plugin_list = {}
var plugins_list = {}

# Load the config.
func load_server_config():
	# Remove all child nodes, so that we don't have clones of plugins.
	for child in get_children():
		child.queue_free()
	# Create the Server Config if it doesn't exist.
	var file = File.new()
	if not file.file_exists(SERVER_CONFIG_PATH):
		var default_data = {
			"server_name": "WEBFISHING HB Server",
			"server_size": 15,
			"server_type": "Public",
			"server_request": false,
			"server_tags": ["talkative", "quiet", "grinding", "chill", "silly", "modded"],
			"plugins": [],
		}
		var err = file.open(SERVER_CONFIG_PATH, File.WRITE)
		if err != OK:
			return false
		file.store_string(JSON.print(default_data, "\t"))
		file.close()

	var error = file.open(SERVER_CONFIG_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse(content)
	if data.error != OK:
		return false
	var json_data = data.result

	# Set variables to the json stuff, man i don't know the names for this i'm bad at commenting.
	server_name = json_data.get("server_name", "")
	server_size = json_data.get("server_size", 0)
	server_type = json_data.get("server_type", "Public")
	server_request = json_data.get("server_request", false)
	server_tags = json_data.get("server_tags", [])

	# Change the Server Types from Strings to Ints.
	if server_type == "Public":
		server_type = 0
	elif server_type == "Unlisted":
		server_type = 1
	elif server_type == "Private":
		server_type = 2
	elif server_type == "Offline":
		server_type = 3
	
	# Server requests are weird, it needs to have this here.
	server_request = not server_request

	# Clear all plugins.
	plugins.clear()
	plugin_settings.clear()

	# Add plugins
	for key in json_data.keys():
		if key == "plugins":
			var raw_plugins = json_data["plugins"]
			if typeof(raw_plugins) == TYPE_ARRAY:
				for plugin in raw_plugins:
					plugins.append(plugin)
		elif key.begins_with("hostbuddy."):
			plugin_settings[key] = json_data[key]

	# Add plugins as a child node.
	for plugin in plugin_list:
		if not plugins.has(plugin):
			print(PREFIX + "Can't find " + plugin + " in " + str(plugins) + ", that means i won't load that.")
			continue
		
		var resource = plugin_list[plugin]
		
		plugins_list[plugin] = resource.new()
		plugins_list[plugin].set_name(plugin.replace(PREFIX, ""))
		add_child(plugins_list[plugin])

	return true

# Load user plugins.
func load_user_plugins():
	# Clear plugins again.
	plugin_list.clear()
	
	# Remove all child nodes.
	for child in get_children():
		child.queue_free()

	# fuck it i won't comment this part anymore bro, i'm too lazy to do that.
	var dir := Directory.new()

	if not dir.dir_exists(PLUGIN_DIR):
		dir.make_dir(PLUGIN_DIR)

	if dir.open(PLUGIN_DIR) != OK:
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".gd"):
			var plugin_name = file_name.get_basename()
			var plugin_path = PLUGIN_DIR + "/" + file_name
			var key = "hostbuddy." + plugin_name

			var script = ResourceLoader.load(plugin_path, "Script", true)
			if script:
				plugin_list[key] = script
		file_name = dir.get_next()
	dir.list_dir_end()

	for key in plugin_list.keys():
		print(PREFIX + "Plugin from plugin folder loaded: " + key)

func _ready() -> void:
	print(PREFIX + "Mod started!")
	load_user_plugins()
	load_server_config()
	get_tree().connect("node_added", self, "_add_HostBuddy_mods")

func _add_HostBuddy_mods(node: Node) -> void:
	if node.name == "main_menu":
		var config_button: Node = HostBuddy_Menu.instance()
		config_button.visible = false

		node.add_child(config_button)

		var menu_list = node.get_node("VBoxContainer")
		var settings_button = menu_list.get_node("settings")
		var button = HostBuddy_Button.instance()
		
		menu_list.add_child(button)
		menu_list.move_child(button, settings_button.get_index() + 1)

		if node.name == "main_menu":
			menu_list.margin_top -= 50
		else:
			menu_list.margin_top -= 25
			menu_list.margin_bottom += 25
	if node.name == "esc_menu":
		var config_button: Node = HostBuddy_Reload.instance()
		config_button.visible = false

		node.add_child(config_button)

		var menu_list = node.get_node("VBoxContainer")
		var settings_button = menu_list.get_node("settings")
		var button = HostBuddy_Reload.instance()
		
		menu_list.add_child(button)
		menu_list.move_child(button, settings_button.get_index() + 1)

		if node.name == "main_menu":
			menu_list.margin_top -= 50
		else:
			menu_list.margin_top -= 25
			menu_list.margin_bottom += 25
# kurwa bober
