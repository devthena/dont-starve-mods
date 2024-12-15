local assets = {
  Asset("ANIM", "anim/chester_eyebone.zip"),
  Asset("ANIM", "anim/chester_eyebone_build.zip"),
  Asset("ANIM", "anim/chester_eyebone_snow_build.zip"),
  Asset("ANIM", "anim/chester_eyebone_shadow_build.zip"),
  Asset("INV_IMAGE", "chester_eyebone"),
  Asset("INV_IMAGE", "chester_eyebone_closed"),
  Asset("INV_IMAGE", "chester_eyebone_closed_shadow"),
  Asset("INV_IMAGE", "chester_eyebone_closed_snow"),
  Asset("INV_IMAGE", "chester_eyebone_shadow"),
  Asset("INV_IMAGE", "chester_eyebone_snow"),
}

local SPAWN_DIST = 30

local function SetEye(inst, inv_img)
  local skin_name = inst:GetSkinName()

  if skin_name ~= nil then
    inv_img = string.gsub(inv_img, "chester_eyebone", skin_name)
  end

  inst.components.inventoryitem:ChangeImageName(inv_img)
end

local function OpenEye(inst)
  if not inst.isOpenEye then
    inst.isOpenEye = true
    SetEye(inst, inst.openEye)
    inst.AnimState:PlayAnimation("idle_loop", true)
  end
end

local function CloseEye(inst)
  if inst.isOpenEye then
    inst.isOpenEye = nil
    SetEye(inst, inst.closedEye)
    inst.AnimState:PlayAnimation("dead", true)
  end
end

local function RefreshEye(inst)
  local inv_img = inst.isOpenEye and inst.openEye or inst.closedEye
  SetEye(inst, inv_img)
end

local function SetBuild(inst)
  local skin_build = inst:GetSkinBuild()

  if skin_build ~= nil then
    local state = ""

    if inst.EyeboneState == "SHADOW" then
      state = "_shadow"
    elseif inst.EyeboneState == "SNOW" then
      state = "_snow"
    end

    inst.AnimState:OverrideItemSkinSymbol("eyeball", skin_build, "eyeball" .. state, inst.GUID, "chester_eyebone")
    inst.AnimState:OverrideItemSkinSymbol("eyebone01", skin_build, "eyebone01" .. state, inst.GUID, "chester_eyebone")
    inst.AnimState:OverrideItemSkinSymbol("lids", skin_build, "lids" .. state, inst.GUID, "chester_eyebone")
  else
    inst.AnimState:ClearAllOverrideSymbols()

    local build = "chester_eyebone_build"

    if inst.EyeboneState == "SHADOW" then
      build = "chester_eyebone_shadow_build"
    elseif inst.EyeboneState == "SNOW" then
      build = "chester_eyebone_snow_build"
    end
    
    inst.AnimState:SetBuild(build)
  end
end

local function MorphShadowEyebone(inst)
  inst.openEye = "chester_eyebone_shadow"
  inst.closedEye = "chester_eyebone_closed_shadow"

  RefreshEye(inst)

  inst.EyeboneState = "SHADOW"
  SetBuild(inst)
end

local function MorphSnowEyebone(inst)
  inst.openEye = "chester_eyebone_snow"
  inst.closedEye = "chester_eyebone_closed_snow"
  
  RefreshEye(inst)

  inst.EyeboneState = "SNOW"
  SetBuild(inst)
end

local function MorphNormalEyebone(inst)
  inst.AnimState:SetBuild("chester_eyebone_build")

  inst.openEye = "chester_eyebone"
  inst.closedEye = "chester_eyebone_closed"
  
  RefreshEye(inst)

  inst.EyeboneState = "NORMAL"
end

local function GetSpawnPoint(pt)
  local theta = math.random() * TWOPI
  local radius = SPAWN_DIST
  local offset = FindWalkableOffset(pt, theta, radius, 12, true)

  return offset ~= nil and (pt + offset) or nil
end

local function SpawnChester(inst)
  local pt = inst:GetPosition()
  local spawn_pt = GetSpawnPoint(pt)

  if spawn_pt ~= nil then
    local chester = SpawnPrefab("cfe_chester", inst.linked_skinname, inst.skin_id)

    if chester ~= nil and inst.PlayerID ~= nil and inst.PlayerName ~= nil then
      chester.PlayerID = inst.PlayerID

      local nickname = inst.PlayerName .. "'s Chester"
      chester.Nickname = nickname

      chester:AddTag(inst.PlayerID .. "_chester")
      chester:AddComponent("named")
      chester.components.named:SetName(nickname)

      chester.Physics:Teleport(spawn_pt:Get())
      chester:FacePoint(pt:Get())

      return chester
    end
  end
end

local StartRespawn

local function StopRespawn(inst)
  if inst.respawntask ~= nil then
    inst.respawntask:Cancel()
    inst.respawntask = nil
    inst.respawntime = nil
  end
end

local function RebindChester(inst, chester)
  chester = chester or TheSim:FindFirstEntityWithTag(inst.PlayerID .. "_chester")
  
  if chester ~= nil then
    OpenEye(inst)
    inst:ListenForEvent("death", function() StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME) end, chester)

    if chester.components.follower.leader ~= inst then
      chester.components.follower:SetLeader(inst)
    end
    return true
  end
end

local function RespawnChester(inst)
  StopRespawn(inst)
  RebindChester(inst, TheSim:FindFirstEntityWithTag(inst.PlayerID .. "_chester") or SpawnChester(inst))
end

StartRespawn = function(inst, time)
  StopRespawn(inst)

  time = time or 0
  inst.respawntask = inst:DoTaskInTime(time, RespawnChester)
  inst.respawntime = GetTime() + time
  
  CloseEye(inst)
end

local function FixChester(inst)
  inst.fixtask = nil

  if not RebindChester(inst) then
    CloseEye(inst)

    if inst.components.inventoryitem.owner ~= nil then
      local time_remaining = inst.respawntime ~= nil and math.max(0, inst.respawntime - GetTime()) or 0
      StartRespawn(inst, time_remaining)
    end
  end
end

local function OnPutInInventory(inst)
  if inst.fixtask == nil then
    inst.fixtask = inst:DoTaskInTime(1, FixChester)
  end
end

local function OnSave(inst, data)
  data.EyeboneState = inst.EyeboneState
  data.PlayerID = inst.PlayerID
  data.PlayerName = inst.PlayerName

  if inst.respawntime ~= nil then
    local time = GetTime()

    if inst.respawntime > time then
      data.respawntimeremaining = inst.respawntime - time
    end
  end
end

local function OnLoad(inst, data)
  if data == nil then
    return
  end

  if data.EyeboneState == "SHADOW" then
      MorphShadowEyebone(inst)
  elseif data.EyeboneState == "SNOW" then
    MorphSnowEyebone(inst)
  end

  if data.respawntimeremaining ~= nil then
    inst.respawntime = data.respawntimeremaining + GetTime()
  else
    OpenEye(inst)
  end

  if data.PlayerID ~= nil then
    inst:AddTag(data.PlayerID .. "_eyebone")
    inst.PlayerID = data.PlayerID
  end

  if data.PlayerName ~= nil then
    if not inst.components.named then
      inst:AddComponent("named")
    end
    
    inst.components.named:SetName(data.PlayerName .. "'s Eye Bone")
    inst.PlayerName = data.PlayerName
  end
end

local function GetStatus(inst)
  return inst.respawntask ~= nil and "WAITING" or nil
end

local function fn()
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddMiniMapEntity()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.MiniMapEntity:SetIcon("chester_eyebone.png")
  inst.MiniMapEntity:SetPriority(7)

  inst:AddTag("cfe_eyebone")
  inst:AddTag("irreplaceable")
  inst:AddTag("nonpotatable")

  inst.AnimState:SetBank("eyebone")
  inst.AnimState:SetBuild("chester_eyebone_build")
  inst.AnimState:PlayAnimation("dead", true)
  inst.scrapbook_anim = "dead"
  inst.scrapbook_specialinfo = "EYEBONE"

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst.EyeboneState = "NORMAL"
  inst.openEye = "chester_eyebone"
  inst.closedEye = "chester_eyebone_closed"
  inst.isOpenEye = nil

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
  inst.components.inventoryitem:ChangeImageName(inst.closedEye)
  inst.components.inventoryitem:SetSinks(true)

  inst:AddComponent("inspectable")
  inst.components.inspectable.getstatus = GetStatus
  inst.components.inspectable:RecordViews()

  inst:AddComponent("leader")

  MakeHauntableLaunch(inst)

  inst.MorphNormalEyebone = MorphNormalEyebone
  inst.MorphSnowEyebone = MorphSnowEyebone
  inst.MorphShadowEyebone = MorphShadowEyebone
  inst.StopRespawn = StopRespawn

  inst.OnLoad = OnLoad
  inst.OnSave = OnSave

  inst.fixtask = inst:DoTaskInTime(1, FixChester)

  inst.RefreshEye = RefreshEye
  inst.SetBuild = SetBuild

  -- additional custom variables
  inst.PlayerID = nil
  inst.PlayerName = nil

  return inst
end

return Prefab("cfe_eyebone", fn, assets)
