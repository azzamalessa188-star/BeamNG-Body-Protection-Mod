-- Body Protection - Vehicle Physics Extension
-- Auto-loaded for every vehicle in physics thread
local M = {}

local isProtected = false
local isInitialized = false
local nonBumperBeams = {}
local originalDeform = {}
local originalStrength = {}
local originalLength = {}

local BUMPER_KEYWORDS = {
  "bumper",
  "bullbar",
  "pushbar",
  "fascia_f",
  "fascia_r",
  "front_fascia",
  "rear_fascia",
  "bar_f",
  "bar_r"
}

local function stringContainsAny(str, patterns)
  if not str or type(str) ~= "string" then return false end
  local lower = string.lower(str)
  for _, pattern in ipairs(patterns) do
    if string.find(lower, pattern, 1, true) then
      return true
    end
  end
  return false
end

local function tableOrStringContainsAny(val, patterns)
  if not val then return false end
  if type(val) == "string" then
    return stringContainsAny(val, patterns)
  elseif type(val) == "table" then
    for _, v in pairs(val) do
      if type(v) == "string" and stringContainsAny(v, patterns) then
        return true
      end
    end
  end
  return false
end

local function isBumperNodeName(name)
  if not name or type(name) ~= "string" then return false end
  local lower = string.lower(name)
  if string.find(lower, "^fb%d") or string.find(lower, "^rb%d") then
    return true
  end
  if string.find(lower, "bumper", 1, true) then
    return true
  end
  return false
end

local function isBumperBeam(b)
  if not b then return false end

  -- 1. Part origin & path
  if b.partOrigin and stringContainsAny(b.partOrigin, BUMPER_KEYWORDS) then
    return true
  end
  if b.partPath and stringContainsAny(b.partPath, BUMPER_KEYWORDS) then
    return true
  end

  -- 2. Break group & deform group
  if b.breakGroup and tableOrStringContainsAny(b.breakGroup, BUMPER_KEYWORDS) then
    return true
  end
  if b.deformGroup and tableOrStringContainsAny(b.deformGroup, BUMPER_KEYWORDS) then
    return true
  end

  -- 3. Beam tags
  if b.tag and tableOrStringContainsAny(b.tag, BUMPER_KEYWORDS) then
    return true
  end

  -- 4. Connected nodes
  if v and v.data and v.data.nodes then
    local n1 = v.data.nodes[b.id1]
    local n2 = v.data.nodes[b.id2]

    if n1 then
      if n1.name and isBumperNodeName(n1.name) then return true end
      if n1.partOrigin and stringContainsAny(n1.partOrigin, BUMPER_KEYWORDS) then return true end
      if n1.group and tableOrStringContainsAny(n1.group, BUMPER_KEYWORDS) then return true end
    end

    if n2 then
      if n2.name and isBumperNodeName(n2.name) then return true end
      if n2.partOrigin and stringContainsAny(n2.partOrigin, BUMPER_KEYWORDS) then return true end
      if n2.group and tableOrStringContainsAny(n2.group, BUMPER_KEYWORDS) then return true end
    end
  end

  return false
end

local function initBeamData()
  if isInitialized then return end
  if not v or not v.data or not v.data.beams then return end

  originalDeform = {}
  originalStrength = {}
  originalLength = {}
  nonBumperBeams = {}

  for cid, b in pairs(v.data.beams) do
    if not isBumperBeam(b) then
      local bCid = b.cid or cid
      originalDeform[bCid] = b.beamDeform or 10000000
      originalStrength[bCid] = b.beamStrength or 10000000
      if obj and obj.getBeamRestLength then
        originalLength[bCid] = obj:getBeamRestLength(bCid)
      end
      table.insert(nonBumperBeams, bCid)
    end
  end

  isInitialized = true
end

local function setEnabled(state)
  initBeamData()
  if not obj then return end

  isProtected = (state == true)

  if isProtected then
    -- Make non-bumper beams completely rigid and unbreakable
    for _, cid in ipairs(nonBumperBeams) do
      obj:setBeamDeform(cid, math.huge)
      obj:setBeamStrength(cid, math.huge)
      -- Restore rest length if slightly deformed previously
      if originalLength[cid] and obj.setBeamLength then
        obj:setBeamLength(cid, originalLength[cid])
      end
    end
  else
    -- Restore original deformation and strength
    for _, cid in ipairs(nonBumperBeams) do
      local def = originalDeform[cid] or 10000000
      local str = originalStrength[cid] or 10000000
      obj:setBeamDeform(cid, def)
      obj:setBeamStrength(cid, str)
    end
  end

  if guihooks and guihooks.trigger then
    guihooks.trigger("BodyProtectionState", { enabled = isProtected })
  end
end

local function toggle()
  setEnabled(not isProtected)
end

local function isEnabled()
  return isProtected
end

local function onReset()
  -- On physics reset (pressing R), re-apply if active
  if isProtected then
    setEnabled(true)
  end
end

local function onVehicleLoaded()
  isInitialized = false
  initBeamData()
end

M.onExtensionLoaded = onVehicleLoaded
M.onVehicleLoaded = onVehicleLoaded
M.onReset = onReset
M.setEnabled = setEnabled
M.toggle = toggle
M.isEnabled = isEnabled

return M
