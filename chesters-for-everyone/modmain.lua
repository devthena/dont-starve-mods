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