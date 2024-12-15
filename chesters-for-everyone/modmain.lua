PrefabFiles = { "cfe_eyebone", "cfe_chester" }

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
	if not name or name == "" then
		player.components.talker:Say("Usage: /rename_chester <name>")
		return
	end

	if name:lower() == "chester" then
		player.components.talker:Say("Hm, better think of another name.")
		return
	end

	local chester = GLOBAL.TheSim:FindFirstEntityWithTag(player.userid .. "_chester")

	if not chester then
		player.components.talker:Say("My Chester is missing!")
		return
	end

	chester:DoTaskInTime(0, function(inst)
		if not inst.components.named then
			inst:AddComponent("named")
		end

		inst.components.named:SetName(name)
		inst.Nickname = name

		local success_message = "I renamed my Chester to " .. name .. "!"
		player.components.talker:Say(success_message)
	end)
end)

AddUserCommand("rename_chester", {
	aliases = { "rc" },
	prettyname = "Rename Chester",
	desc = "Rename your own Chester with a custom name.",
	permission = GLOBAL.COMMAND_PERMISSION.USER,
	params = { "n1", "n2", "n3" },
	paramsoptional = { false, true, true },
	slash = true,
	usermenu = false,
	servermenu = false,
	vote = false,
	localfn = function(params)
		local s = (params.n1 or "") .. " " .. (params.n2 or "") .. " " .. (params.n3 or "")
		s = s:match("^%s*(.-)%s*$")
		SendModRPCToServer(GetModRPC(id_table.namespace, id_table.id), s)
	end,
})
