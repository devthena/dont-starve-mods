name = "Chesters for Everyone"
description = [[
Version 0.9.0 (Beta)

This mod spawns a personal Eye Bone for each player, giving everyone their very own Chester!

Rename your Chester using chat commands:
/rename_chester <name>
/rc <name> (short version)





Note: This mod does not spawn a Snow or Shadow Chester. The player is still responsible for its transformation.
]]
author = "Athena"
version = "0.9.0"
api_version = 10

configuration_options = {
	{
		name = "chester_access",
		label = "Chester Inventory Access",
		hover = "The level of access for all personal Chesters. Setting it to Private means players can only open their own Chesters.",
		options = {
			{
				description = "Public (Default)",
				data = "public",
			},
			{
				description = "Private",
				data = "private",
			},
		},
		default = "public",
	},
}

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"
