extends Node

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

var PlayerAPI

func _ready():
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_added", self, "_player_added")

func _player_added(player):
	Network._send_message(KikinHostBuddy.plugin_settings["hostbuddy.greetingmsg"]["greeting_msg"], "63d481")
