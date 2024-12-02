local SAVE_DATA_FILE = "save_data.json"
local save_data = {}

-- Spawns an Eye Bone for a new player
local function SpawnEyeBone(player)
  local player_name = player:GetDisplayName()
  local eyebone = GLOBAL.SpawnPrefab("chester_eyebone")
  local x, y, z = player.Transform:GetWorldPosition()

  eyebone.Transform:SetPosition(x + 3, y, z)

  save_data[player.userid] = player_name
  GLOBAL.TheSim:SetPersistentString(SAVE_DATA_FILE, GLOBAL.json.encode(save_data))
end

-- Handler for player join event
local function OnPlayerJoin(player)
  local state = save_data[player.userid]

  if not state then
    SpawnEyeBone(player)
  end
end

AddPrefabPostInit("world", function(inst)
  -- Loads player data when server starts
  GLOBAL.TheSim:GetPersistentString(SAVE_DATA_FILE, function(success, data)
    if success == true and data ~= nil then
      save_data = GLOBAL.json.decode(data)
    end
  end)

  -- Listens for player join events
  inst:ListenForEvent("ms_playerjoined", function(_inst, player)
    if player then
        OnPlayerJoin(player)
    end
  end)
end)