PrefabFiles = { "cfe_eyebone", "cfe_chester" }

local prompts_private = require("prompts/private_chester")
local prompts_taken = require("prompts/name_taken")
local prompts_rename = require("prompts/rename_chester")

local chester_access = GetModConfigData("chester_access")
local chester_rename = GetModConfigData("chester_rename")

local function SpawnEyeBone(player)
	local player_name = player:GetDisplayName()
	local x, y, z = player.Transform:GetWorldPosition()

	local eyebone = GLOBAL.SpawnPrefab("cfe_eyebone")

	eyebone.PlayerID = player.userid
	eyebone.PlayerName = player_name

	eyebone:AddTag(player.userid .. "_eyebone")
	eyebone:AddComponent("named")
	eyebone.components.named:SetName(player_name .. "'s Eye Bone")

	eyebone.Transform:SetPosition(x + 3, y, z)
end

local function OnPlayerJoin(player)
	if GLOBAL.TheWorld:HasTag("cave") then
		return
	end

	if GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_eyebone") == nil then
		SpawnEyeBone(player)
	end
end

local function OnContainerOpen(self)
	local original_open = self.Open
	if not original_open then
		return
	end

	function self:Open(doer)
		if chester_access == "private" and self.inst.PlayerID ~= doer.userid then
			local locked_message = prompts_private[doer.prefab] or "Hm, this is not my Chester."
			doer.components.talker:Say(locked_message)
			return
		end

		original_open(self, doer)
	end
end

GLOBAL.PREFAB_SKINS["cfe_chester"] = GLOBAL.PREFAB_SKINS["chester"]
GLOBAL.PREFAB_SKINS["cfe_eyebone"] = GLOBAL.PREFAB_SKINS["chester_eyebone"]

AddPrefabPostInit("cfe_chester", function(inst)
	if inst.components.container then
		OnContainerOpen(inst.components.container)
	end
end)

AddSimPostInit(function()
	if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
		GLOBAL.TheWorld:ListenForEvent("ms_playerjoined", function(_inst, player)
			if player then
				OnPlayerJoin(player)
			end
		end)
	end
end)

local id_table = {
	namespace = "chesters-for-everyone",
	id = "rename_chester",
}

AddModRPCHandler(id_table.namespace, id_table.id, function(player, name)
	if not chester_rename then
		player.components.talker:Say("I can't do that in this server.")
		return
	end

	if not name or name == "" then
		player.components.talker:Say("Usage: /rename_chester <name>")
		return
	end

	if name:lower() == "chester" then
		local basic_name_message = prompts_taken[player.prefab] or "Hm, maybe another name."
		player.components.talker:Say(basic_name_message)
		return
	end

	local chester = GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_chester")

	if not chester then
		local missing_message = "Oh no... Chester is missing!"
		player.components.talker:Say(missing_message)
		return
	end

	chester:DoTaskInTime(0, function(inst)
		if not inst.components.named then
			inst:AddComponent("named")
		end

		inst.components.named:SetName(name)
		inst.Nickname = name

		local rename_message = prompts_rename(player.prefab, name)
		player.components.talker:Say(rename_message)
	end)
end)

AddUserCommand("rename_chester", {
	aliases = { "rc" },
	prettyname = "Rename Chester",
	desc = "Rename your own Chester with a custom name.",
	permission = GLOBAL.COMMAND_PERMISSION.USER,
	params = { "name", "n2", "n3" },
	paramsoptional = { false, true, true },
	slash = true,
	usermenu = false,
	servermenu = false,
	vote = false,
	localfn = function(params)
		local s = (params.name or "") .. " " .. (params.n2 or "") .. " " .. (params.n3 or "")
		s = s:match("^%s*(.-)%s*$")
		SendModRPCToServer(GetModRPC(id_table.namespace, id_table.id), s)
	end,
})
