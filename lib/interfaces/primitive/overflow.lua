
local event = require 'event'

local CHECK_INTERVAL = 3.0

return function(tank, output_name)
 local trigger = 10000000
 
 local function check()
  if trigger <= 0 then
   return
  end
  if tank.tank.amount > trigger then
   tank[output_name] = true
  end
 end

 event.timer(CHECK_INTERVAL, check, math.huge)

 return {
  set = function(new)
   trigger = new
  end,
  get = function()
   return trigger
  end,
 }
end