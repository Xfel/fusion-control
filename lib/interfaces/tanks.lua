--[[
 file: tanks.lua
 description:
  gives access to the main tanks
]]
local newTank = require 'interfaces.primitive.tank'
local quickRS = require 'interfaces.primitive.quickrs'
local data = require 'data.interfaces'
local properties = require 'interfaces.properties'
local reserve = require 'interfaces.primitive.reserve'
local overflow = require 'interfaces.primitive.overflow'

local tanks = {}
--generating...
for name, tankData in pairs(data.tanks) do
 local tank = {
  item = tankData.item,
  mixed = tankData.mixed,
 }
 --tank data
 local props = {
  tank = newTank(tankData.tank),
 }
 --redstone
 quickRS(props, tankData.redstone)
 --reserve and overflow properties (e.g. for plasma tank)
 if tankData.limited then
  props.reserve = reserve(tank, tankData.limited)
  props.overflow = overflow(tank, tankData.limited)
 end
 tank = properties(props, tank)
 
 tanks[tankData.item] = tank
 tanks[name] = tank
end
return tanks