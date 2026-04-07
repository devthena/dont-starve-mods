PrefabFiles = { "hfe_fishbowl", "hfe_hutch" }

local strings = require("strings")

local hutch_rename = GetModConfigData("hutch_rename")

local function SpawnFishBowl(player)
	local player_name = player:GetDisplayName()
	local x, y, z = player.Transform:GetWorldPosition()
	local pt = Vector3(x, y, z)

	local theta = math.random() * 2 * math.pi
	local offset = FindWalkableOffset(pt, theta, 3, 8, true)
	local spawn_pt = offset ~= nil and (pt + offset) or pt

	local fishbowl = SpawnPrefab("hfe_fishbowl")

	fishbowl.PlayerID = player.userid
	fishbowl.PlayerName = player_name

	fishbowl:AddTag(player.userid .. "_fishbowl")
	fishbowl:AddComponent("named")
	fishbowl.components.named:SetName(player_name .. "'s Star-Sky")

	fishbowl.Transform:SetPosition(spawn_pt:Get())
end

local function OnPlayerJoin(player)
	if TheWorld == nil or not TheWorld:HasTag("cave") then
		return
	end

	if TheSim:FindFirstEntityWithTag(player.userid .. "_fishbowl") == nil then
		SpawnFishBowl(player)
	end
end

PREFAB_SKINS["hfe_hutch"] = PREFAB_SKINS["hutch"]
PREFAB_SKINS["hfe_fishbowl"] = PREFAB_SKINS["hutch_fishbowl"]

local id_table = {
	namespace = "hutches-for-everyone",
	id = "rename_hutch",
}

AddSimPostInit(function()
	if TheWorld ~= nil and TheWorld.ismastersim and TheWorld:HasTag("cave") then
		TheWorld:ListenForEvent("ms_playerjoined", function(_, player)
			if player then
				OnPlayerJoin(player)
			end
		end)
	end
end)

AddModRPCHandler(id_table.namespace, id_table.id, function(player, name)
	if not hutch_rename then
		player.components.talker:Say(strings.system.rename_disabled)
		return
	end

	if not name or name == "" then
		player.components.talker:Say(strings.system.rename_usage)
		return
	end

	if #name > 30 then
		player.components.talker:Say(strings.system.name_too_long)
		return
	end

	if name:lower() == "hutch" then
		player.components.talker:Say(strings.name_taken[player.prefab] or strings.name_taken.DEFAULT)
		return
	end

	local hutch = TheSim:FindFirstEntityWithTag(player.userid .. "_hutch")

	if not hutch then
		player.components.talker:Say(strings.system.companion_missing)
		return
	end

	if not hutch.components.named then
		hutch:AddComponent("named")
	end

	hutch.components.named:SetName(name)
	hutch.Nickname = name

	local template = strings.rename[player.prefab] or strings.rename.DEFAULT
	player.components.talker:Say((template:gsub("{name}", name)))
end)

AddUserCommand("rename_hutch", {
	aliases = { "rh" },
	prettyname = "Rename Hutch",
	desc = "Rename your own Hutch with a custom name.",
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
