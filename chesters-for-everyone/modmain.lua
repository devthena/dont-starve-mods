-- Import Declarations
local require = GLOBAL.require
local json = require "json"

-- Constants Declarations
local EYEBONE_DATA_FILE = "data/eyebone_data.lua"
local PLAYER_DATA_FILE = "data/player_data.lua"
local SAVE_INTERVAL = 600 -- 10 minutes

-- Variable Declarations
local player_data = {}
local eyebone_data = {}

-- Creates a data directory if it does not exist
local function CreateSaveDirectory()
  if not GLOBAL.TheSim:GetFilePath("data") then
    GLOBAL.TheSim:CreateDirectory("data")
  end
end

-- Saves player data
local function SavePlayerData()
  local file = io.open(PLAYER_DATA_FILE, "w")

  if file then
    local json_data = json.encode(player_data)
    file:write(json_data)
    file:close()
  end
end

-- Saves eyebone data
local function SaveEyeBoneData()
  local file = io.open(EYEBONE_DATA_FILE, "w")

  if file then
    for player_id, eyebone in pairs(player_data) do
      local chester = eyebone.chester
       eyebone_data[player_id] = {
        eyebone_location = eyebone:GetPosition(),
        chester_location = chester:GetPosition(),
        chester_inventory = chester.components.inventory:GetItems(),
      }
    end

    local json_data = json.encode(eyebone_data)
    file:write(json_data)
    file:close()
  end
end

-- Saves eyebone data periodically
local function PeriodicSave()
  SaveEyeBoneData()
end

-- Loads player data
local function LoadPlayerData()
  local file = io.open(PLAYER_DATA_FILE, "r")
  if file then
    local json_data = file:read("*a")
    player_data = json.decode(json_data)
    file:close()
  end
end

-- Loads eyebone data
local function LoadEyeBoneData()
  local file = io.open(EYEBONE_DATA_FILE, "r")
  if file then
    local json_data = file:read("*a")
    eyebone_data = json.decode(json_data)
    file:close()
  end
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

CreateSaveDirectory()
LoadPlayerData()
LoadEyeBoneData()

-- Listens for join and disconnect events
GLOBAL.TheWorld:ListenForEvent("ms_playerjoined", function(_, data)
  local player = GLOBAL.TheWorld.net.components.playerlist:GetPlayerByUserID(data.userid)
  if player then
      OnPlayerJoin(player)
  end
end)

GLOBAL.TheWorld:ListenForEvent("ms_playerleft", function(_, data)
  local player = GLOBAL.TheWorld.net.components.playerlist:GetPlayerByUserID(data.userid)
  if player then
      OnPlayerDisconnect()
  end
end)

-- Starts a periodic save of eyebone data
GLOBAL.TheWorld:DoTaskInTime(SAVE_INTERVAL, PeriodicSave)