--[[
 file: machine.lua
 description:
  the base for every machine
]]
local interfaces = require 'interfaces.interfaces'
local misc = require 'misc'

return function(props, machine)
 --checking for extra requirements (e.g. valve positions)
 local requirement = machine.requirement
 if requirement then
  requirement = misc.getter(requirement)
 end
 
 props.available = props.available or function()
  --machine could be running if it was enabled / if it had energy
  --eu is special to avoid infinite recursion when checking the availability and to adapt the code to the different eu sources
  local recipe = machine.recipe
  if recipe then
   if requirement and not requirement(interfaces) then
    return false
   end
   for ingredient, amount in pairs(recipe.ingredients) do
    if amount < 0 and ingredient ~= "eu" then
     if not interfaces.availability[ingredient] then
      return false
     end
    end
   end
   return true
  end
  return false
 end
 props.running = props.running or function()
  return machine.enabled and machine.available
 end
 props.rate = props.rate or function()
  local recipe = machine.recipe
  if recipe and machine.running  then
   return recipe.rate
  end
  return newRate{}
 end
 return props, machine
end