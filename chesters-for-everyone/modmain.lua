PrefabFiles = { "cfe_eyebone", "cfe_chester" }

local SAVE_DATA_FILE = "cfe_save_data.json"
local save_data = {}

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

  save_data[player.userid] = player_name
end

local function OnPlayerJoin(player)
  if GLOBAL.TheWorld:HasTag("cave") then
    return
  end

  local player_data = save_data[player.userid]

  if not player_data then
    SpawnEyeBone(player)
  end
end

AddSimPostInit(function()
  GLOBAL.TheSim:GetPersistentString(SAVE_DATA_FILE, function(success, data)
    if success == true and data ~= nil then
      save_data = GLOBAL.json.decode(data)
    end
  end)

  if GLOBAL.TheWorld ~= nil and GLOBAL.TheWorld.ismastersim then
    GLOBAL.TheWorld:ListenForEvent("ms_save", function ()
      GLOBAL.TheSim:SetPersistentString(SAVE_DATA_FILE, GLOBAL.json.encode(save_data))
    end)

    GLOBAL.TheWorld:ListenForEvent("ms_playerleft", function ()
      GLOBAL.TheSim:SetPersistentString(SAVE_DATA_FILE, GLOBAL.json.encode(save_data))
    end)

    GLOBAL.TheWorld:ListenForEvent("ms_playerjoined", function(_inst, player)
      if player then
          OnPlayerJoin(player)
      end
    end)
  end
end)