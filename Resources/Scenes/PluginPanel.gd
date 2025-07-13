extends Panel

onready var KikinHostBuddy = get_node_or_null("/root/KikinHostBuddy")

var is_enabled

func _ready():
	if KikinHostBuddy.module_references["ConfigManager"].enabled_plugins.has(name):
		is_enabled = true
	else:
		is_enabled = false
	
	if is_enabled:
		$AddOrRemove.text = "-"
	else:
		$AddOrRemove.text = "+"

func _on_AddOrRemove_pressed():
	if not is_enabled:
		$AddOrRemove.text = "-"
		KikinHostBuddy.module_references["ConfigManager"].enabled_plugins.append(name)
	else:
		$AddOrRemove.text = "+"
		KikinHostBuddy.module_references["ConfigManager"].enabled_plugins.erase(name)
	KikinHostBuddy.module_references["ConfigManager"].save_plugins_enabled()
	is_enabled = not is_enabled
