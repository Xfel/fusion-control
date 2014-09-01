--[[
 file: availability.lua
 description:
  contains information whether or not a resource is produced or on storage and can be used for further processing
]]

local interfaces = require 'interfaces.interfaces'
local properties = require 'interfaces.properties'
local items = require 'data.items'

return properties{
 [items.plasma] = function()
  --at least 1000 mB in storage to exclude short term fluctuations on an empty tank
  return interfaces.tanks.plasma.tank.amount > 1
 end,
 eu = function()
  --a negative balance causes problems with the machines ("insufficient energy line" - resets)
  return interfaces.balance.eu >= 0
 end,
 [items.hydrogen] = function()
  if interfaces.me.hydrogen > 8 then
   return true
  end
  for _,el in ipairs(interfaces.machines.electrolyzers) do
   if el.recipe.items[items.hydrogen] > 0 and el.running then
    return true
   end
  end
  return false
 end,
 [items.deuterium] = function() --only the item, deuterium inside the quantum tank is not 'available' for all uses
  if interfaces.me.deuterium > 8 then
   return true
  end
  for _,cen in ipairs(interfaces.machines.centrifuges) do
   if cen.recipe.items[items.deuterium] > 0 and cen.running then
    return true
   end
  end
  return false
 end,
 [items.cells] = function() --only the item, deuterium inside the quantum tank is not 'available' for all uses
  return true
 end,
}