# ---------------------------------------------
extends Node
# ---------------------------------------------
const DEFAULT_SOURCE = "https://raw.githubusercontent.com/iamkikin-off/hostbuddy-plugin-source/refs/heads/main/default_plugins.json" # The default source for HostBuddy Plugin Loader.

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")
onready var HostBuddyPlugin = preload("res://mods/Kikin.HostBuddy/Resources/Scripts/HostBuddyPlugin.gd")

var http_request : HTTPRequest
var all_plugins = {} # Contains the plugin name & the plugin code.
var loaded_plugins = {} # Contains the plugin name (for downloading) & the plugin code (in a HostBuddyPlugin node)
var current_source = "https://raw.githubusercontent.com/iamkikin-off/hostbuddy-plugin-source/refs/heads/main/default_plugins.json"
var current_plugin_index : int
var sources = {}
# ---------------------------------------------
func _ready():
	
	http_request = HTTPRequest.new()
	get_parent().add_child(http_request)
	
	check_for_plugins()
	
	KikinHostBuddy.debug_message("Plugin Loader [✔]", name)
# ---------------------------------------------
func _on_request_completed_source(result, response_code, headers, body):
	
	var json = JSON.parse(body.get_string_from_utf8())
	
	all_plugins = json.result["plugins"]
	KikinHostBuddy.debug_message("Source: " + json.result["source_name"] + ", has " + str(all_plugins.size()) + " plugin/s.", name)
	current_plugin_index = 0
	sources[json.result["source_name"]] = current_source
	load_plugins()
# ---------------------------------------------
func _on_request_completed_plugin(result, response_code, headers, body):
	
	var newPlugin = HostBuddyPlugin.new()
	newPlugin.plugin_code = body.get_string_from_utf8()
	newPlugin.plugin_name = all_plugins.keys()[current_plugin_index]
	
	loaded_plugins[newPlugin.plugin_name] = newPlugin
	KikinHostBuddy.debug_message("All loaded plugins: " + str(loaded_plugins), name)
	
	current_plugin_index += 1
	load_plugins()
# ---------------------------------------------
func check_for_plugins():
	http_request.disconnect("request_completed", self, "_on_request_completed_source")
	http_request.disconnect("request_completed", self, "_on_request_completed_plugin")
	http_request.connect("request_completed", self, "_on_request_completed_source")
	http_request.request(current_source)
# ---------------------------------------------
func load_plugins():
	
	if current_plugin_index >= all_plugins.size():
		KikinHostBuddy.debug_message("All plugins loaded", name)
		return
	
	var key = all_plugins.keys()[current_plugin_index]
	var codeURL = all_plugins[key]["code"]
	
	http_request.disconnect("request_completed", self, "_on_request_completed_source")
	http_request.connect("request_completed", self, "_on_request_completed_plugin")
	http_request.request(codeURL)
# ---------------------------------------------
func download_and_run(plugin, clear_node):
	KikinHostBuddy.debug_message("All Plugins are: " + str(all_plugins), name)
	KikinHostBuddy.debug_message("Loaded Plugins are: " + str(loaded_plugins), name)
	
	KikinHostBuddy.debug_message("Downloading and running: " + str(plugin), name)
	
	var code = loaded_plugins[plugin].plugin_code
	var fileName = "user://plugin_%s.gd" % loaded_plugins[plugin].plugin_name
	
	var file = File.new()
	if file.open(fileName, File.WRITE) == OK:
		file.store_string(code)
		file.close()
		
		var script = load(fileName)
		if script:
			var node = Node.new()
			node.set_script(script)
			node.name = loaded_plugins[plugin].plugin_name
			clear_node.add_child(node)
			KikinHostBuddy.debug_message("Plugin %s loaded" % loaded_plugins[plugin].plugin_name, name)
# ---------------------------------------------
