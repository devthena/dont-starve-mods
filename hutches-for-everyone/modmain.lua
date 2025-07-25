PrefabFiles = { "hfe_fishbowl", "hfe_hutch" }

local prompts_private = require("prompts/private_hutch")
local prompts_taken = require("prompts/name_taken")
local prompts_rename = require("prompts/rename_hutch")

local hutch_access = GetModConfigData("hutch_access")
local hutch_rename = GetModConfigData("hutch_rename")

local function SpawnFishBowl(player)
	local player_name = player:GetDisplayName()
	local x, y, z = player.Transform:GetWorldPosition()

	local hutch = GLOBAL.SpawnPrefab("hfe_fishbowl")

	hutch.PlayerID = player.userid
	hutch.PlayerName = player_name

	hutch:AddTag(player.userid .. "_fishbowl")
	hutch:AddComponent("named")
	hutch.components.named:SetName(player_name .. "'s Star-Sky")

	hutch.Transform:SetPosition(x + 3, y, z)
end

local function OnPlayerJoin(player)
	if GLOBAL.TheWorld == nil or not GLOBAL.TheWorld:HasTag("cave") then
		return
	end

	if GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_fishbowl") == nil then
		SpawnFishBowl(player)
	end
end

local function OnContainerOpen(self)
	local original_open = self.Open
	if not original_open then
		return
	end

	function self:Open(doer)
		if hutch_access == "private" and self.inst.PlayerID ~= doer.userid then
			local locked_message = prompts_private[doer.prefab] or "Hm, this is not my Hutch."
			doer.components.talker:Say(locked_message)
			return
		end

		original_open(self, doer)
	end
end

GLOBAL.PREFAB_SKINS["hfe_hutch"] = GLOBAL.PREFAB_SKINS["hutch"]
GLOBAL.PREFAB_SKINS["hfe_fishbowl"] = GLOBAL.PREFAB_SKINS["hutch_fishbowl"]

local id_table = {
	namespace = "hutches-for-everyone",
	id = "rename_hutch",
}

AddPrefabPostInit("hfe_hutch", function(inst)
	if inst.components.container then
		OnContainerOpen(inst.components.container)
	end
end)

AddSimPostInit(function()
	if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim and GLOBAL.TheWorld:HasTag("cave") then
		GLOBAL.TheWorld:ListenForEvent("ms_playerjoined", function(_inst, player)
			if player then
				OnPlayerJoin(player)
			end
		end)
	end
end)

AddModRPCHandler(id_table.namespace, id_table.id, function(player, name)
	if not hutch_rename then
		player.components.talker:Say("I can't do that in this server.")
		return
	end

	if not name or name == "" then
		player.components.talker:Say("Usage: /rename_hutch <name>")
		return
	end

	if name:lower() == "hutch" then
		local basic_name_message = prompts_taken[player.prefab] or "Hm, maybe another name."
		player.components.talker:Say(basic_name_message)
		return
	end

	local hutch = GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_hutch")

	if not hutch then
		local missing_message = "Oh no... Hutch is missing!"
		player.components.talker:Say(missing_message)
		return
	end

	hutch:DoTaskInTime(0, function(inst)
		if not inst.components.named then
			inst:AddComponent("named")
		end

		inst.components.named:SetName(name)
		inst.Nickname = name

		local rename_message = prompts_rename(player.prefab, name)
		player.components.talker:Say(rename_message)
	end)
end)

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
