--[[
 file: availability.lua
 description:
  contains information whether or not a resource is produced or on storage and can be used for further processing
]]

local interfaces = require 'interfaces.interfaces'
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
  return interfaces.me.hydrogen > 32 or interfaces.balance.hydrogen_production > 0
 end,
 [items.deuterium] = function() --only the item, deuterium inside the quantum tank is not 'available' for all uses
  return interfaces.me.deuterium > 32 or interfaces.balance.deuterium_production > 0
 end,
 [items.cells] = function() --only the item, deuterium inside the quantum tank is not 'available' for all uses
  return true
 end,
},