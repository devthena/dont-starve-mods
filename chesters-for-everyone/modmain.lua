-- Constants Declarations
local EYEBONE_DATA_FILE = "data/eyebone_data.json"
local PLAYER_DATA_FILE = "data/player_data.json"
local SAVE_INTERVAL = 600 -- 10 minutes

-- Variable Declarations
local player_data = {}
local eyebone_data = {}

-- Saves player data
local function SavePlayerData()
  GLOBAL.TheSim:SetPersistentString(PLAYER_DATA_FILE, GLOBAL.json.encode(player_data))
end

-- Saves eyebone data
local function SaveEyeBoneData()
  for player_id, eyebone in pairs(player_data) do
    local chester = eyebone.chester
      eyebone_data[player_id] = {
      eyebone_location = eyebone:GetPosition(),
      chester_location = chester:GetPosition(),
      chester_inventory = chester.components.inventory:GetItems(),
    }
    end

    GLOBAL.TheSim:SetPersistentString(EYEBONE_DATA_FILE, GLOBAL.json.encode(eyebone_data))
end

-- Saves eyebone data periodically
local function PeriodicSave()
  SaveEyeBoneData()
end

-- Loads player data
local function LoadPlayerData()
  GLOBAL.TheSim:GetPersistentString(PLAYER_DATA_FILE, function(success, data)
    if success == true and data ~= nil then
      player_data = GLOBAL.json.decode(data)
    end
  end)
end

-- Loads eyebone data
local function LoadEyeBoneData()
  GLOBAL.TheSim:GetPersistentString(EYEBONE_DATA_FILE, function(success, data)
    if success == true and data ~= nil then
      eyebone_data = GLOBAL.json.decode(data)
    end
  end)
end

-- Spawns an Eye Bone for existing players
local function SpawnEyeBone(player, eyebone_state)
  local player_name = player:GetDisplayName()
  local eyebone = GLOBAL.TheWorld:SpawnPrefab("eyebone")

  local eyebone_pos = eyebone_state.eyebone_location
  local chester_pos = eyebone_state.chester_location
  local chester_inv = eyebone_state.chester_inventory

  eyebone.Transform:SetPosition(eyebone_pos.x, eyebone_pos.y, eyebone_pos.z)
  eyebone.components.named:SetCustomName(player_name .. "'s Eyebone")

  local chester = eyebone.chester
  
  chester.Transform:SetPosition(chester_pos.x, chester_pos.y, chester_pos.z)

  for _, item in ipairs(chester_inv) do
    chester.components.inventory:GiveItem(item)
  end

  player_data[player.userid] = eyebone
  SavePlayerData()
end

-- Spawns an Eye Bone for new players
local function SpawnNewEyeBone(player)
  local player_name = player:GetDisplayName()
  local eyebone = GLOBAL.TheWorld:SpawnPrefab("eyebone")
  local x, y, z = player.Transform:GetWorldPosition()

  eyebone.Transform:SetPosition(x + 2, y, z)
  eyebone.components.named:SetCustomName(player_name .. "'s Eyebone")

  player_data[player.userid] = eyebone
  SavePlayerData()
end

-- Handler for Player Disconnect event
local function OnPlayerDisconnect()
  SaveEyeBoneData()
end

-- Handler for Player Join event
local function OnPlayerJoin(player)
  local eyebone_state = eyebone_data[player.userid]

  if eyebone_state then
    SpawnEyeBone(player, eyebone_state);
    return
  end

  SpawnNewEyeBone(player)
end

LoadPlayerData()
LoadEyeBoneData()

AddPrefabPostInit("world", function(inst)
  -- Listens for player join events
  inst:ListenForEvent("ms_playerjoined", function(_, data)
    if data then
        OnPlayerJoin(data)
    end
  end)

  -- Listens for player disconnect events
  inst:ListenForEvent("ms_playerleft", OnPlayerDisconnect)

  -- Starts a periodic save of eyebone data
  inst:DoTaskInTime(SAVE_INTERVAL, PeriodicSave)
end)