--[[
 Diese Funktion kümmert sich um die Verteilung des Deuteriums.
 Der Rückgabewert besteht aus der 'property',
 mit der das Verhalten eingestellt werden kann,
 und der steuernden Funktion

]]
-- imports
local event = require 'event'

local TIMER_INTERVAL = 2.0

return function(tankD,tankT,centrifuges)
 local mode = ""
 local dEnabled,tEnabled = false,false
 local log = false
 
 local callback = function()
  if tankD.tank.amount < tankT.tank.amount and dEnabled then
   if log then print(1) end
   tankD.input = true
   centrifuges.deuterium = false
  elseif tEnabled then
   if log then print(2) end
   tankD.input = false
   centrifuges.deuterium = true
  elseif dEnabled then
   if log then print(3) end
   tankD.input = true
   centrifuges.deuterium = false
  else
   if log then print(4) end
   tankD.input = false
   centrifuges.deuterium = false
  end
  if log then
   log = false
   print(tankD.tank.amount,tankT.tank.amount,dEnabled,tEnabled)
  end
 end
 event.timer(TIMER_INTERVAL, callback, math.huge)
 
 return {
  set = function(new)
   mode = string.lower(new)
   dEnabled,tEnabled,log = string.match(mode,"(d?)(t?)(l?)")
  end,
  get = function()
   return mode
  end,
 }
end