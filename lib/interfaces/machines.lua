--[[
 file: quicksum.lua
 description:
  loads all machines
]]

local quickSum = require 'interfaces.primitives.quicksum'
local properties = require 'interfaces.properties'

local list = {}
--load machines
for _,name in ipairs{"centrifuges", "electrolyzers"} do
 list[name] = require("interfaces."..name)
end
--create a summing function
local props = {
 rate = function()
  return quickSum(list, "rate", pairs)
 end,
}

return properties(props, list)