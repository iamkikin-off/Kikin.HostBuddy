extends Node

var PlayerAPI

func _ready():
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")
	PlayerAPI.connect("_player_removed", self, "_player_removed")

func _player_removed(player):
	Network._send_message(KikinHostBuddy.plugin_settings["hostbuddy.goodbyemsg"]["goodbye_msg"], "d47c63")
