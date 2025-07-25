name = "Hutches for Everyone"
description = [[
Version v0.1.2 (BETA)

This mod spawns a Star-Sky for each player entering the Caves, giving all players their very own Hutch!

Rename your Hutch using chat commands:

/rename_hutch <name>
/rh <name> (short version)




Note: This mod does not spawn a Fugu or Music Box Hutch. The player is still responsible for its transformation.
]]
author = "Athena"
version = "0.1.2"
api_version = 10

configuration_options = {
	{
		name = "hutch_rename",
		label = "Allow Hutch Rename",
		hover = "Set if players are allowed to rename their own Hutches.",
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
		name = "hutch_access",
		label = "Hutch Inventory Access",
		hover = "Set if players can open all Hutches or only their own.",
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
