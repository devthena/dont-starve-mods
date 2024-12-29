name = "Chesters for Everyone"
description = [[
Release v1.0.0

This mod spawns an Eye Bone for each player entering the world, giving all players their very own Chester!

Rename your Chester using chat commands:

/rename_chester <name>
/rc <name> (short version)




Note: This mod does not spawn a Snow or Shadow Chester. The player is still responsible for its transformation.
]]
author = "Athena"
version = "1.0.0"
api_version = 10

configuration_options = {
	{
		name = "chester_rename",
		label = "Allow Chester Rename",
		hover = "Set if players are allowed to rename their own Chesters.",
		options = {
			{
				description = "Enabled",
				data = true,
			},
			{
				description = "Disabled",
				data = false,
			},
		},
		default = true,
	},
	{
		name = "chester_access",
		label = "Chester Inventory Access",
		hover = "Set if players can open all Chesters or only their own.",
		options = {
			{
				description = "Public",
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
