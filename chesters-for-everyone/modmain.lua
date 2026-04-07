PrefabFiles = { "cfe_eyebone", "cfe_chester" }

local prompts_taken = require("prompts/name_taken")
local prompts_rename = require("prompts/rename_chester")

local chester_rename = GetModConfigData("chester_rename")

local function SpawnEyeBone(player)
	local player_name = player:GetDisplayName()
	local x, y, z = player.Transform:GetWorldPosition()
	local pt = Vector3(x, y, z)

	local theta = math.random() * 2 * math.pi
	local offset = FindWalkableOffset(pt, theta, 3, 8, true)
	local spawn_pt = offset ~= nil and (pt + offset) or pt

	local eyebone = SpawnPrefab("cfe_eyebone")

	eyebone.PlayerID = player.userid
	eyebone.PlayerName = player_name

	eyebone:AddTag(player.userid .. "_eyebone")
	eyebone:AddComponent("named")
	eyebone.components.named:SetName(player_name .. "'s Eye Bone")

	eyebone.Transform:SetPosition(spawn_pt:Get())
end

local function OnPlayerJoin(player)
	if TheWorld:HasTag("cave") then
		return
	end

	if TheSim:FindFirstEntityWithTag(player.userid .. "_eyebone") == nil then
		SpawnEyeBone(player)
	end
end

PREFAB_SKINS["cfe_chester"] = PREFAB_SKINS["chester"]
PREFAB_SKINS["cfe_eyebone"] = PREFAB_SKINS["chester_eyebone"]

AddSimPostInit(function()
	if TheWorld ~= nil and TheWorld.ismastersim then
		TheWorld:ListenForEvent("ms_playerjoined", function(_, player)
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

	if #name > 30 then
		player.components.talker:Say("That name is too long!")
		return
	end

	if name:lower() == "chester" then
		local basic_name_message = prompts_taken[player.prefab] or "Hm, maybe another name."
		player.components.talker:Say(basic_name_message)
		return
	end

	local chester = TheSim:FindFirstEntityWithTag(player.userid .. "_chester")

	if not chester then
		player.components.talker:Say("Oh no... Chester is missing!")
		return
	end

	if not chester.components.named then
		chester:AddComponent("named")
	end

	chester.components.named:SetName(name)
	chester.Nickname = name

	player.components.talker:Say(prompts_rename(player.prefab, name))
end)

AddUserCommand("rename_chester", {
	aliases = { "rc" },
	prettyname = "Rename Chester",
	desc = "Rename your own Chester with a custom name.",
	permission = COMMAND_PERMISSION.USER,
	params = { "name", "n2", "n3", "n4", "n5" },
	paramsoptional = { false, true, true, true, true },
	slash = true,
	usermenu = false,
	servermenu = false,
	vote = false,
	localfn = function(params)
		local parts = {}
		for _, key in ipairs({ "name", "n2", "n3", "n4", "n5" }) do
			if params[key] and params[key] ~= "" then
				table.insert(parts, params[key])
			end
		end
		SendModRPCToServer(GetModRPC(id_table.namespace, id_table.id), table.concat(parts, " "))
	end,
})
