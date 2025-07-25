local hutch_access = GetModConfigData("hutch_access")
local hutch_rename = GetModConfigData("hutch_rename")

local id_table = {
	namespace = "hutches-for-everyone",
	id = "rename_hutch",
}

AddUserCommand("rename_hutch", {
	aliases = { "rh" },
	prettyname = "Rename Hutch",
	desc = "Rename your own Hutch with a custom name.",
	permission = GLOBAL.COMMAND_PERMISSION.USER,
	params = { "first", "middle", "last" },
	paramsoptional = { false, true, true },
	slash = true,
	usermenu = false,
	servermenu = false,
	vote = false,
	localfn = function(params)
		local s = (params.first or "") .. " " .. (params.middle or "") .. " " .. (params.last or "")
		s = s:match("^%s*(.-)%s*$")
		SendModRPCToServer(GetModRPC(id_table.namespace, id_table.id), s)
	end,
})
