# ---------------------------------------------
extends Node
# ---------------------------------------------
const SERVER_CONFIG_PATH : String = "user://hostbuddy_server_config.json" # The path to the server config.
const PLUGINS_ENABLED_PATH : String = "user://hostbuddy_enabled_plugins.json" # The path to the server config.
# ---------------------------------------------
var server_name : String = "" # The server name.
var server_size : int = 0 # The server size. (The player cap)
var server_type = 0 # The server type. (Stored as int, later turned into string.)
var server_tags : Array = [] # The server tags.
var server_request = false # Does the player need to request to join?
var enabled_plugins = []
# ---------------------------------------------
func make_example_config(file, type):
	match type:
		"SERVER_CONFIG":
			var default_data = {
				"server_name": "WEBFISHING HB Server",
				"server_size": 15,
				"server_type": "Public",
				"server_request": false,
				"server_tags": ["talkative", "quiet", "grinding", "chill", "silly", "modded"],
			}
			var err = file.open(SERVER_CONFIG_PATH, File.WRITE)
			if err != OK:
				return false
			file.store_string(JSON.print(default_data, "\t"))
			file.close()
		"PLUGINS_ENABLED":
			var default_data = {
				"enabled_plugins": []
			}
			var err = file.open(PLUGINS_ENABLED_PATH, File.WRITE)
			if err != OK:
				return false
			file.store_string(JSON.print(default_data, "\t"))
			file.close()
# ---------------------------------------------
func load_server_config():
	# Reading the config & setting variables.
	var file = File.new()
	if not file.file_exists(SERVER_CONFIG_PATH):
		make_example_config(file, "SERVER_CONFIG")

	var error = file.open(SERVER_CONFIG_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse(content)
	if data.error != OK:
		return false
	var json_data = data.result
	
	server_name = json_data.get("server_name", "")
	server_size = json_data.get("server_size", 0)
	server_type = json_data.get("server_type", "Public")
	server_request = json_data.get("server_request", false)
	server_tags = json_data.get("server_tags", [])

	# String (from the json) -> int (for server creation function)
	if server_type == "Public":
		server_type = 0
	elif server_type == "Unlisted":
		server_type = 1
	elif server_type == "Private":
		server_type = 2
	elif server_type == "Offline":
		server_type = 3

	# Server requests are behaving weird, so we just change it.
	server_request = not server_request

	return true

func save_config():
	var file = File.new()
	var error = file.open(SERVER_CONFIG_PATH, File.WRITE)
	if error != OK:
		return false

	var json_data = {
		"server_name": server_name,
		"server_size": server_size,
		"server_type": server_type,
		"server_request": server_request,
		"server_tags": server_tags,
	}
	var content = JSON.print(json_data, "\t")
	file.store_string(content)
	file.close()
	return true
# ---------------------------------------------
func load_plugins_enabled():
	# Reading the config & setting variables.
	var file = File.new()
	if not file.file_exists(PLUGINS_ENABLED_PATH):
		make_example_config(file, "PLUGINS_ENABLED")

	var error = file.open(PLUGINS_ENABLED_PATH, File.READ)
	if error != OK:
		return false
	var content = file.get_as_text()
	file.close()

	var data = JSON.parse(content)
	if data.error != OK:
		return false
	var json_data = data.result
	
	enabled_plugins = json_data.get("enabled_plugins", [])

	return true

func save_plugins_enabled():
	var file = File.new()
	var error = file.open(PLUGINS_ENABLED_PATH, File.WRITE)
	if error != OK:
		return false

	var json_data = {
		"enabled_plugins": enabled_plugins
	}
	var content = JSON.print(json_data, "\t")
	file.store_string(content)
	file.close()
	return true
# ---------------------------------------------
