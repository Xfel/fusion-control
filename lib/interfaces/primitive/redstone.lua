--[[
 file: redstone.lua
 description:
  This is the base for every redstone based control.
]]

local component = require 'component'

-------------------------- REDSTONE --------------------------
-- small xor function
local function xor(a,b)
 if a then
  return not b
 elseif b then
  return true
 else
  return false
 end
end

-- erzeugt eine Funktion, die den redstone-Status an der gegebenen stelle liest. Die funktion gibt true oder false zurück.
local function rsBRead(address, side, color, inverted)
  if color then
    return function()
      return xor(component.invoke(address, "getBundledInput", side, color) > 0, inverted)
    end
  else
    return function()
      return xor(component.invoke(address, "getInput", side) > 0, inverted)
    end
  end
end

-- erzeugt eine Funktion, die den redstone-Status an der gegebenen stelle schreibt. Die funktion akzeptiert true oder false.
local function rsBWrite(address, side, color, inverted)
  if color then
    return function(val)
      val = xor(val, inverted)
      -- normalize
      if val == true then
        val = 15
      elseif val == false then
        val = 0
      end
      
      component.invoke(address, "setBundledOutput", side, color, val)
    end
  else
    return function(val)
      val = xor(val, inverted)
      -- normalize
      if val == true then
        val = 15
      elseif val == false then
        val = 0
      end
      
      component.invoke(address, "setOutput", side, val)
    end
  end
end

return function (address, side, color, inverted)
  return { 
    get = rsBRead(address, side, color, inverted), 
    set = rsBWrite(address, side, color, inverted),
  }
end
