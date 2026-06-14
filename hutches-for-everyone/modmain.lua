PrefabFiles = { "hfe_fishbowl", "hfe_hutch" }

local strings = require("strings")

local hutch_rename = GetModConfigData("hutch_rename")

local function SpawnFishBowl(player)
	local player_name = player:GetDisplayName()
	local x, y, z = player.Transform:GetWorldPosition()
	local pt = GLOBAL.Vector3(x, y, z)

	local theta = math.random() * 2 * math.pi
	local offset = GLOBAL.FindWalkableOffset(pt, theta, 3, 8, true)
	local spawn_pt = offset ~= nil and (pt + offset) or pt

	local fishbowl = GLOBAL.SpawnPrefab("hfe_fishbowl")

	fishbowl.PlayerID = player.userid
	fishbowl.PlayerName = player_name

	fishbowl:AddTag(player.userid .. "_fishbowl")
	fishbowl:AddComponent("named")
	fishbowl.components.named:SetName(player_name .. "'s Star-Sky")

	fishbowl.Transform:SetPosition(spawn_pt:Get())

	local sx, sy, sz = spawn_pt:Get()
	print("[Hutches for Everyone] Spawned Fish Bowl for", player_name, "at", sx, sy, sz)
end

local function OnPlayerJoin(world, player)
	print("[Hutches for Everyone] Player joined:", player:GetDisplayName(), "| userid:", player.userid)

	if not world:HasTag("cave") then
		print("[Hutches for Everyone] Skipping Fish Bowl spawn — not cave shard")
		return
	end

	if GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_fishbowl") == nil then
		SpawnFishBowl(player)
	else
		print("[Hutches for Everyone] Fish Bowl already exists for", player:GetDisplayName())
	end
end

local id_table = {
	namespace = "hutches-for-everyone",
	id = "rename_hutch",
}

AddPrefabPostInit("world", function(inst)
	print("[Hutches for Everyone] Registering ms_playerjoined listener")
	inst:ListenForEvent("ms_playerjoined", function(_, player)
		if player then
			OnPlayerJoin(inst, player)
		end
	end)
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

	local hutch = GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_hutch")

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
	permission = 0,
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
