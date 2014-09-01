--[[
 file: quickrs.lua
 description:
  simplifies the creation of redstone controls by creating a list of redstone properties from a list of addresses + other data
]]

local properties = require 'interfaces.properties'
local machine = require 'interfaces.primitives.machine'
local quickSum = require 'quicksum'
local recipes = require 'data.recipes'
local data = require 'data.interfaces'
local interfaces = require 'interfaces.interfaces'
local newRate = require 'data.newRate'

local function generator(data)
 local gen = {
  recipe = data.recipe,
  requirement = data.requirement,
 }
 local props = {}
 quickRS(props, data.redstone)
 return properties(machine(props, gen))
end

local list = {}
local props = {
 rate = function()
  local maxRate = quickSum(list, "rate", ipairs)
  local maxUsage = interfaces.machines.rate.eu or 0
  local euRate = math.min(maxRate.eu, -maxUsage.eu)
  return newRate{
   eu = euRate,
   [items.plasma] = (euRate / maxRate.eu) * maxRate[items.plasma],
  }
 end,
}

for index, generatorData in ipairs(data.generators) do
 list[index] = generator(generatorData)
end

return properties(props, list)