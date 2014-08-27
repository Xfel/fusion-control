-- imports
local interfaces = require 'config.interfaces'
local items = require 'config.items'
local recipes = require 'config.recipes'
local component = require 'component'
--set primary screen to direct io.write and io.read to the right direction
component.setPrimary("gpu", interfaces.screens.control.address)
component.setPrimary("screen", interfaces.screens.control.screen_address)

--possible escape sequences:
local special_chars={
 s=" ",
 t="\t",
 r="\r",
 n="\n",
 ["\\"]="\\",
}

local function evaluate(txt,env)
 local func, err = load("return "..txt,nil,nil,env)
 if func then
  local ok, val = pcall(func)
  if ok then
   return val
  else
   return txt
  end
 else
  return txt
 end
end

local enabledValues = {
 on = true,   ["1"] = true, ["true"] = true,
 off = false, ["0"] = false,["false"] = false,
}
local stateNames = {
 [true] = "enabled",
 [false] = "disabled",
}

local function getStateValue(state)
 if state==nil then
  return nil
 end
 state = string.lower(state)
 return enabledValues[state]
end



local commands = {
 recipe = function(recipe)
  if recipe ~= nil then
   local new = evaluate(recipe, recipes)
   interfaces.reactor.recipe = new
  end
  local equation=(interfaces.reactor.recipe or {}).equation or ""
  print("Now running: "..equation)
 end,
 turn = function(state)
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.reactor.enabled = value
  end
  print("Reactor "..stateNames[interfaces.reactor.enabled])
 end,
 generator = function(nr, state)
  nr = evaluate(nr)
  assert(nr and nr>=1 and nr<=4,"Invalid generator id")
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.generators[nr].enabled = value
  end
  print("Generator #"..nr.." "..stateNames[interfaces.generators[nr].enabled])
 end,
 centrifuge = function(nr, state)
  nr = evaluate(nr)
  assert(nr and nr>=1 and nr<=6,"Invalid centrifuge id")
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.machines.centrifuges[nr].energy = value
  end 
  print("Centrifuge #"..nr.." "..stateNames[interfaces.machines.centrifuges[nr].energy])
 end,
 electrolyzer = function(state)
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.machines.electrolyzer[1].energy = value
  end 
  print("Electrolyzer "..stateNames[interfaces.machines.electrolyzer[1].energy])
 end,
 cells = function(state)
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.machines.electrolyzer.cells = value
  end
  print("Cells -> Electrolyzer "..stateNames[interfaces.machines.electrolyzer.cells])
 end,
 hydrogen = function(state)
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.machines.centrifuges.hydrogen = value
  end
  print("Hydrogen -> Centrifuges "..stateNames[interfaces.machines.centrifuges.hydrogen])
 end,
 deuterium = function(state)
  if state ~= nil then
   interfaces.reactor.deuterium_distribution = state
  end
  print("Deuterium distribution: "..tostring(interfaces.reactor.deuterium_distribution))
  print("Deuterium -> Centrifuges "..stateNames[interfaces.machines.centrifuges.deuterium])
  print("Deuterium -> Tank "..stateNames[interfaces.tanks.deuterium.input])
 end,
 tanks = function()
  for id,tank in pairs(interfaces.tanks) do
   if type(id) == "string" then
    print(id..": "..math.floor(tank.tank.amount / 1000))
   end
  end
 end,
 plasma = function(position,state)
  local positions = {
   reactor = "output_reactor",
   generators = "output_generators",
   export = "output_export",
  }
  local key = positions[position]
  assert(key, "Unknown plasma output '"..position.."' !")
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.tanks.plasma[key] = value
  end
  print("Plasma -> "..position.." "..stateNames[interfaces.tanks.plasma[key]])
 end,
 primer = function(state)
  local value = getStateValue(state)
  if value ~= nil then
   interfaces.reactor.primer = value
  end
  print("Primer "..stateNames[interfaces.reactor.primer])
 end,
 reserve = function(amount)
  local value = tonumber(amount)
  if value ~= nil then
   interfaces.reactor.plasma_reserve = value * 1000.0
  end
  print("Plasma Reserve: " .. interfaces.reactor.plasma_reserve / 1000.0)
 end,
}



while true do
 --read line
 io.write("> ")
 local line = io.read("*l")
 if line == nil or line == "exit" then
  --end of program execution
  return
 end
 --extract arguments
 local args = {}
 for arg in string.gmatch(line, "[^%s]+") do
  arg = string.gsub(arg, "\\(.)", special_chars)
  args[#args+1]=arg
 end
 --execute
 if #args>0 then
  local func = commands[args[1]]
  if func then
   pcall(func, table.unpack(args,2))
  end
 end
end