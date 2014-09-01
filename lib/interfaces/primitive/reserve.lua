
local event = require 'event'

local CHECK_INTERVAL = 3.0

return function(tank, output_name)
 local reserve = 1000000
 
 local function check()
  if reserve <= 0 then
   return
  end
  if tank.tank.amount < reserve then
   tank[output_name] = false
  end
 end

 event.timer(CHECK_INTERVAL, check, math.huge)

 return {
  set = function(new)
   reserve = new
  end,
  get = function()
   return reserve
  end,
 }
end