-- Body Protection - Game Engine Extension
-- Controls global invincibility state and synchronizes with vehicle VM and UI
local M = {}

M.dependencies = {"core_input_actions"}

local isEnabled = false

local function notifyUI()
  if guihooks and guihooks.trigger then
    guihooks.trigger("BodyProtectionState", { enabled = isEnabled })
  end
end

local function applyToVehicle(veh, state)
  if not veh then return end
  local cmd = string.format([[
    if bodyProtection then
      bodyProtection.setEnabled(%s)
    elseif extensions and extensions.bodyProtection then
      extensions.bodyProtection.setEnabled(%s)
    else
      extensions.load("auto/bodyProtection")
      if bodyProtection then
        bodyProtection.setEnabled(%s)
      end
    end
  ]], tostring(state), tostring(state), tostring(state))
  veh:queueLuaCommand(cmd)
end

local function applyToAllVehicles(state)
  if not be then return end
  local count = be:getObjectCount()
  for i = 0, count - 1 do
    local v = be:getObject(i)
    if v then
      applyToVehicle(v, state)
    end
  end
end

local function setInvincibility(state)
  isEnabled = (state == true)

  -- Apply to current player vehicle and all active vehicles
  if be then
    local playerVeh = be:getPlayerVehicle(0)
    if playerVeh then
      applyToVehicle(playerVeh, isEnabled)
    else
      applyToAllVehicles(isEnabled)
    end
  end

  -- In-game notification banner
  local msg = isEnabled and "حماية البدي: مفعّل (الصدامات مستثناة فقط) | Body Shield: ON"
                         or "حماية البدي: معطّل (الفيزياء الطبيعية) | Body Shield: OFF"
  if ui_message then
    ui_message(msg, 3, "bodyProtection")
  elseif guihooks and guihooks.message then
    guihooks.message(msg, 3, "bodyProtection")
  end

  notifyUI()
end

local function toggle()
  setInvincibility(not isEnabled)
end

local function requestState()
  notifyUI()
end

local function isProtectionEnabled()
  return isEnabled
end

-- Hooks for vehicle lifecycle
local function onVehicleSpawned(vehId)
  if isEnabled and be then
    local veh = be:getObjectByID(vehId)
    if veh then
      applyToVehicle(veh, true)
    end
  end
  notifyUI()
end

local function onVehicleResetted(vehId)
  if isEnabled and be then
    local veh = be:getObjectByID(vehId)
    if veh then
      applyToVehicle(veh, true)
    end
  end
end

local function onVehicleSwitched(oldId, newId)
  if isEnabled and be then
    local veh = be:getObjectByID(newId)
    if veh then
      applyToVehicle(veh, true)
    end
  end
  notifyUI()
end

local function onReset()
  if isEnabled and be then
    local veh = be:getPlayerVehicle(0)
    if veh then
      applyToVehicle(veh, true)
    end
  end
end

-- Quick access (Radial Menu) integration
local function setupQuickAccess()
  if core_quickAccess then
    core_quickAccess.addEntry({
      level = "/root/",
      generator = function(entries)
        table.insert(entries, {
          title = isEnabled and "درع البدي: مفعل" or "درع البدي: معطل",
          icon = isEnabled and "shield" or "shield_outline",
          onSelect = function()
            toggle()
            return {"reload"}
          end
        })
      end
    })
  end
end

local function onExtensionLoaded()
  log("I", "bodyProtection", "Body Protection GE extension loaded")
  setupQuickAccess()
  notifyUI()
end

-- Public interface
M.onExtensionLoaded = onExtensionLoaded
M.setInvincibility = setInvincibility
M.toggle = toggle
M.requestState = requestState
M.isEnabled = isProtectionEnabled
M.onVehicleSpawned = onVehicleSpawned
M.onVehicleResetted = onVehicleResetted
M.onVehicleSwitched = onVehicleSwitched
M.onReset = onReset

return M
