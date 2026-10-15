-- Legacy controller compatibility wrapper
local M = {}
M.type = "auxiliary"

local function toggle()
  if bodyProtection then
    bodyProtection.toggle()
  elseif extensions and extensions.bodyProtection then
    extensions.bodyProtection.toggle()
  end
end

local function setPartialInvincibility(state)
  if bodyProtection then
    bodyProtection.setEnabled(state)
  elseif extensions and extensions.bodyProtection then
    extensions.bodyProtection.setEnabled(state)
  end
end

local function isEnabled()
  if bodyProtection then
    return bodyProtection.isEnabled()
  elseif extensions and extensions.bodyProtection then
    return extensions.bodyProtection.isEnabled()
  end
  return false
end

M.init = function() end
M.togglePartialInvincibility = toggle
M.setPartialInvincibility = setPartialInvincibility
M.isEnabled = isEnabled

return M
