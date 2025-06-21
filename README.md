# HostBuddy - A tool that helps you host WF servers.
**HostBuddy** is a simple tool that helps you host WebFishing servers.

**HostBuddy** lives in your Main Menu, where instead of clicking "Create Game", you click "[!] HostBuddy" to open the **HostBuddy** menu.

# Config
```json
{
	"server_name": "HB Server - Modded",
	"server_size": 10,
	"server_type": "Public",
	"server_request": false,
	"server_tags": [
		"talkative",
		"quiet",
		"grinding",
		"chill",
		"silly"
	],
	"plugins": [
		"hostbuddy.greetingmsg",
		"hostbuddy.goodbyemsg",
		"hostbuddy.automsg"
	],
	"hostbuddy.greetingmsg": {
		"greeting_msg": "%u, welcome! This is a testing server for HostBuddy, a tool for hosting Webfishing servers."
	},
	"hostbuddy.goodbyemsg": {
		"goodbye_msg": "Bye %u!"
	},
	"hostbuddy.automsg": {
		"color": "0356fc",
		"messages": ["%u", "%u is cool", "Apple", "hi eli"],
		"time": 5
	}
}
```

> "server_name" - The name for your server (doesn't support characters like "4","|")

> "server_size" - The size for your server, anything above 12 will get flagged as "Modded"

> "server_type" - The visibility of your server, (Public, Unlisted, Private, Offline)

> "server_request" - If True, people will need to be accepted to join.

> "plugins" - If you want any plugins on your server (Every plugin needs to start with "hostbuddy.", and needs to be in the HB_Plugins directory)

> "hostbuddy.pluginname" - The settings for the plugin, they should be listed on https://dsc.gg/iamkikin

> %u - Player

# Plugins
**HostBuddy** supports plugins.
For ex. do you want a greeting message when someone joins your server? Well you can join https://dsc.gg/iamkikin to get the **"hostbuddy.greetingmsg"** plugin, and then put it in your config and plugin dir.

There are a lot more plugins for **HostBuddy**, so if you want more... join our [Discord](https://discord.gg/vmnXWtU35K)!

# Custom Plugins
Custom Plugin guide coming soon.
