--[[
 file: electrolyzers.lua
 description:
  describes the electrolyzers
]]

local properties = require 'interfaces.properties'
local machine = require 'interfaces.primitive.machine'
local quickSum = require 'interfaces.primitive.quicksum'
local quickRS = require 'interfaces.primitive.quickrs'
local data = require 'data.interfaces'

local function electrolyzer(data)
 local el = {
  recipe = data.recipe,
  requirement = data.requirement,
 }
 local props = {}
 quickRS(props, data.redstone)
 return properties(machine(props, el))
end

local list = {}
local props = {
 rate = function()
  return quickSum(list, "rate", ipairs)
 end,
}
quickRS(props, data.machines.electrolyzers.redstone)

for index, electrolyzerData in ipairs(data.machines.electrolyzers) do
 list[index] = electrolyzer(electrolyzerData)
end

return properties(props, list)