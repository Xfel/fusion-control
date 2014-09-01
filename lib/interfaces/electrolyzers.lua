--[[
 file: electrolyzers.lua
 description:
  describes the electrolyzers
]]

local properties = require 'interfaces.properties'
local machine = require 'interfaces.primitives.machine'
local quickSum = require 'quicksum'
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
quickRS(props, data.electrolyzers.redstone)

for index, electrolyzerData in ipairs(data.electrolyzers) do
 list[index] = centrifuge(electrolyzerData)
end

return properties(props, list)