--[[
 file: centrifuges.lua
 description:
  describes the centrifuges
]]

local properties = require 'interfaces.properties'
local machine = require 'interfaces.primitive.machine'
local quickSum = require 'interfaces.primitive.quicksum'
local quickRS = require 'interfaces.primitive.quickrs'
local data = require 'data.interfaces'

local function centrifuge(data)
 local cen = {
  recipe = data.recipe,
  requirement = data.requirement,
 }
 local props = {}
 quickRS(props, data.redstone)
 return properties(machine(props, cen))
end

local list = {}
local props = {
 rate = function()
  return quickSum(list, "rate", ipairs)
 end,
}
quickRS(props, data.machines.centrifuges.redstone)

for index, centrifugeData in ipairs(data.machines.centrifuges) do
 list[index] = centrifuge(centrifugeData)
end

return properties(props, list)