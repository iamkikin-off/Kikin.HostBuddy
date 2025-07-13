# ---------------------------------------------
extends Node
# ---------------------------------------------
const VERSION = "v1.2"
const PREFIX = "[HostBuddy | " + VERSION + "] "
const SERVER_CONFIG_PATH = "user://hostbuddy_server_config.json"
const PLUGIN_DIR := "user://HB_Plugins"
const HOSTBUDDY_BUTTON := preload("res://mods/Kikin.HostBuddy/Resources/Scenes/HostBuddy-config.tscn")
const HOSTBUDDY_RELOAD := preload("res://mods/Kikin.HostBuddy/Resources/Scenes/HostBuddy-ReloadPlugins.tscn")
const HOSTBUDDY_MENU := preload("res://mods/Kikin.HostBuddy/Resources/Scenes/config-menu/HostBuddy-menu.tscn")
const MODULES = {
	"PluginLoader": {"code": preload("res://mods/Kikin.HostBuddy/Modules/PluginLoader.gd")},
	"ConfigManager": {"code": preload("res://mods/Kikin.HostBuddy/Modules/ConfigManager.gd")},
}

onready var Players = get_node_or_null("/root/ToesSocks/Players") as Node
onready var Chat = get_node_or_null("/root/ToesSocks/Chat") as Node

var module_references = {}
var plugins_node : Node = Node.new()
var is_debug = OS.has_feature("editor")
var in_menu
# ---------------------------------------------
func _ready():
	debug_message("Hostbuddy is running.", name)
	
	load_all_modules()
	
	plugins_node.name = "Plugins"
	add_child(plugins_node)
	
	module_references["ConfigManager"].load_server_config()
	module_references["ConfigManager"].load_plugins_enabled()
	
	get_tree().connect("node_added", self, "_add_HostBuddy_mods")
# ---------------------------------------------
func download_all_plugins_and_run():
	for plugin in module_references["ConfigManager"].enabled_plugins:
		module_references["PluginLoader"].download_and_run(plugin, plugins_node)
# ---------------------------------------------
func load_all_modules():
	debug_message("Loading modules..", name)
	for module in MODULES.keys():
		var newNode : Node  = Node.new()
		newNode.set_script(MODULES[module]["code"])
		newNode.name = module
		module_references[module] = newNode
		add_child(newNode)
	debug_message("Loaded modules.", name)
# ---------------------------------------------
func debug_message(msg, module_name):
	print(PREFIX + "[" + str(module_name) + "] " + str(msg))
# ---------------------------------------------
func _add_HostBuddy_mods(node: Node) -> void:
	if node.name == "world":
		if Network.GAME_MASTER and not in_menu:
			for node in plugins_node.get_children():
				node.queue_free()
			module_references["ConfigManager"].load_server_config()
			module_references["ConfigManager"].load_plugins_enabled()
			download_all_plugins_and_run()
	if node.name == "main_menu":
		var config_button: Node = HOSTBUDDY_MENU.instance()
		config_button.visible = false
		
		in_menu = true

		node.add_child(config_button)

		var menu_list = node.get_node("VBoxContainer")
		var settings_button = menu_list.get_node("settings")
		var button = HOSTBUDDY_BUTTON.instance()

		menu_list.add_child(button)
		menu_list.move_child(button, settings_button.get_index() + 1)

		if node.name == "main_menu":
			menu_list.margin_top -= 50
		else:
			menu_list.margin_top -= 25
			menu_list.margin_bottom += 25
	if node.name == "esc_menu" and Network.GAME_MASTER:
		var config_button: Node = HOSTBUDDY_RELOAD.instance()
		config_button.visible = false

		node.add_child(config_button)

		var menu_list = node.get_node("VBoxContainer")
		var settings_button = menu_list.get_node("settings")
		var button = HOSTBUDDY_RELOAD.instance()

		menu_list.add_child(button)
		menu_list.move_child(button, settings_button.get_index() + 1)

		if node.name == "main_menu":
			menu_list.margin_top -= 50
		else:
			menu_list.margin_top -= 25
			menu_list.margin_bottom += 25
	if node.name == "loading_menu":
		in_menu = false
# ---------------------------------------------
# Whoever reads this code.. you stink.
