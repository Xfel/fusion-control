--[[
 file: balance.lua
 description:
  Summarizes production and consumption rates of various things.
]]

local interfaces = require 'interfaces.interfaces'
local properties = require 'interfaces.properties'
local items = require 'data.items'
local recipes = require 'data.recipes'

local props = {
 eu = function()
  return interfaces.generators.rate.eu + interfaces.machines.rate.eu
 end,
 plasma_generators = function()
  return interfaces.generators.rate[items.plasma]
 end,
 plasma_reactor = function()
  return interfaces.reactor.rate.eu / recipes.plasma_energy.items.eu
 end,
 plasma_output = function()
  return interfaces.reactor.rate[items.plasma] or 0
 end,
 plasma = function()
  return interfaces.balance.plasma_output + interfaces.balance.plasma_generators + interfaces.balance.plasma_reactor
 end,
 hydrogen_production = function() --production only
  return interfaces.machines.rate[items.hydrogen]
 end,
 deuterium_production = function() --production only
  return interfaces.machines.rate[items.deuterium]
 end,
 total = function()
  local rate = (interfaces.reactor.rate + interfaces.machines.rate + interfaces.generators.rate)
  rate[items.plasma] = interfaces.balance.plasma
  return rate
 end
}


return properties(props)