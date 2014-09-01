--[[
 file: reactor.lua
 description:
  the central component of this project
]]

local data = require 'data.interfaces'
local recipes = require 'data.recipes'
local eu = require 'interfaces.primitive.eu'
local quickRS = require 'interfaces.primitive.quickrs'
local tank = require 'interfaces.primitive.tank'
local machine = require 'interfaces.primitive.machine'
local distributor = require 'interfaces.primitive.distributor'
local mixer = require 'interfaces.primitive.mixer'
local properties = require 'interfaces.properties'

local tanks = require 'interfaces.tanks' --objects necessary for initialization, should be the only case where an explicit require is necessary
local machines = require 'interfaces.machines'

local reactor = {}
--add injectors
for _,name in ipairs{"input_east", "input_west"} do
 local input = {
  tank = tank(data.reactor[name].tank)
 }
 quickRS(input, data.reactor[name].redstone)
 reactor[name] = properties(input)
end

--add properties
local props = {
 energy = eu(data.reactor.energy),
 available = function()
  --not using standard available because that might cause a loop
  --another reason: The reactor uses resources from a tank. availability only checks items in the me system and items being produced
  local recipe = reactor.recipe
  --check for recipe
  if not recipe then
   return false
  end
  local tank_east = reactor.input_east.tank
  local tank_west = reactor.input_west.tank
  local tanks = {tank_east, tank_west}
  local items = recipe.items
  
  --get items in injectors
  local availableItems = {}
  for _, tank in ipairs(tanks) do
   if tank.type then
    availableItems[tank.type] = tank.amount / 1000.0
   end
  end
  --check if there is the correct content in the injectors
  for item, balance in pairs(items) do
   if balance < 0 then
    if item == "eu" then
     balance = balance + reactor.energy
     if tanks.plasma.output_reactor then
      balance = balance + tanks.plasma.tank.amount * recipes.plasma_energy.items.eu
     end
     if balance < 0 then
      return false
     end
    else
     local availableAmount = availableItems[item] or 0
     if availableAmount <= -balance then
      return false
     end
    end
   end
  end
  return true
 end,
 output = function()
  --compatibility function which only returns the result of the reaction
  local output = reactor.rate
  local outputType = nil
  local outputRate = 0
  
  for item, amount in pairs(output) do
   if amount > 0 then
    outputType = item,
    outputRate = amount,
   end
  end
  return {type = outputType, rate = outputRate}
 end,
 
 deuterium_distribution = distributor(
  tanks.deuterium,
  tanks.tritium,
  machines.centrifuges
 ),
}
quickRS(props, data.reactor.redstone)

props.recipe = mixer(
 tanks,
 {
  reactor.input_east,
  reactor.input_west,
 }
)

return properties(machine(props, reactor))