extends Node

var PlayerAPI
var time = 0

func _ready():
	print("hi")
	PlayerAPI = get_node_or_null("/root/BlueberryWolfiAPIs/PlayerAPI")

func _process(delta):
	if PlayerAPI:
		if PlayerAPI.in_game:
			time = time + delta
			if time >= KikinHostBuddy.plugin_settings["hostbuddy.automsg"]["time"]:
				var random_msg = KikinHostBuddy.plugin_settings["hostbuddy.automsg"]["messages"]
				random_msg.shuffle()
				var final_msg = random_msg[0]
				Network._send_message(final_msg, str(KikinHostBuddy.plugin_settings["hostbuddy.automsg"]["color"]))
				time = 0
