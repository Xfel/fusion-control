--[[
 Diese Funktion vereinfacht die Handhabung des Reaktors in der Form,
 dass man das Rezept selbst einstellen kann.
 Beim Rezept 'nil' wird die Treibstoffrückführung dauerhaft aktiviert.


]]

local event = require 'event'
local CLEANING_TIME = 20.0
local CHECK_INTERVAL = 1.0


return function(tanks, inputs)
 local current = nil, old
 local function check()
  if new ~= current or current == nil then
   --disable output, start recycling
   for _,tank in pairs(tanks) do
    if tank.mixed then
     tank.output = false
    end
   end
   for _,input in pairs(inputs) do
    input.recycle = true
   end
   if current ~= nil then
    --*BUSY*
    os.sleep(CLEANING_TIME)
    --stop recycling, output is set in next part
    for _,input in pairs(inputs) do
     input.recycle = false
    end
   end
  end
  ---set new output state---
  if current ~= nil then
   --prepare output table
   local output = {}
   for _,ingredient in ipairs(current.ingredients) do
    output[ingredient]=true
   end
   --set tank output
   for _,tank in pairs(tanks) do
    if tank.mixed then
     if output[tank.item] then
      tank.output=true
     else
      tank.output=false
     end
    end
   end
  end
  old = current
 end
 
 event.timer(0.1,function()
  while true do
   check()
   os.sleep(CHECK_INTERVAL)
  end
 end)
 
 return {
  set = function(new)
   current = new
  end,
  get = function()
   return current
  end,
 }
end