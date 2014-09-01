---fluids
--storage
tank      ("tanks.helium3",       14, 12)
tank      ("tanks.tritium",       33, 12)
tank      ("tanks.wolframium",    52, 12)
tank      ("tanks.lithium",       14, 18)
tank      ("tanks.deuterium",     33, 18)
tank      ("tanks.berylium",      52, 18)
tank      ("tanks.plasma",       123, 15)
tank_small("reactor.input_east",  80,  6, "Input East")
tank_small("reactor.input_west",  80, 24, "Input West")
--rate
production("reactor.output",      98, 19, "Producing")
local balance_output = "(reactor.rate[items.plasma] or 0)"
local balance_reactor = "(reactor.rate.eu or 0) / recipes.plasma_energy.items.eu"
local balance_machines = "generators.rate[items.plasma] or 0"
fluid_balance(balance_output, 125, 37)
fluid_balance(balance_reactor, 125, 39)
fluid_balance(balance_machines, 125, 41)
fluid_balance(balance_output .. "+" .. balance_reactor .. "+" .. balance_machines, 125, 43)
---items
item      ("me.helium3",       20, 26)
item      ("me.tritium",       20, 28)
item      ("me.deuterium",     20, 30)
item      ("me.lithium",       34, 26)
item      ("me.berylium",      34, 28)
item      ("me.wolframium",    34, 30)
item      ("me.cells",         56, 49)
item      ("me.hydrogen",      86, 49)
item      ("me.iridium",      126, 23)
item      ("me.platinum",     126, 25)
---energy
--storage
energy    ("(reactor.recipe or {}).initial", 99, 9)
energy    ("reactor.energy",      99, 7)
percentage(function()
 local current = reactor.energy
 local initial = (reactor.recipe or {}).initial
 if initial then
  if current > initial then
   return 1
  end
  return current / initial
 else
  return "N/A"
 end
end, 105, 11)
--rate
energy_balance("machines.electrolyzers.rate.eu or 0", 21, 38)
energy_balance("machines.centrifuges.rate.eu or 0",   21, 40)
energy_balance("machines.rate.eu or 0",   21, 42)
energy_balance("generators.rate.eu or 0", 21, 47)
---recipe information
equation  ("(reactor.recipe or {}).equation", 125, 7)
cycles(function()
 local recipe = reactor.recipe
 if recipe then
  local cycles = math.huge
  for ingredient, amount in ipairs(recipe.items) do
   --only check things that are used
   if amount < 0 and ingredient ~= "eu" then
    --the fuel reserve is calculated for a running reactor with all currently enabled machines
    if reactor.running then
     amount = balance[ingredient]
    else
   --include reactor's costs
     amount = amount + balance[ingredient]
    end
    if amount < 0 then
     local tank = tanks[ingredient].tank
     local thisReserve = -tank.amount / amount
     cycles = math.min(cycles, thisReserve)
    end
   end
  end
  return cycles
 end
end, 125, 9)
cycles(function()
 local recipe = reactor.recipe
 if recipe then
  local storage = tanks.plasma.tank.amount + reactor.energy / recipes.plasma_energy.items.eu
  local balance = balance.total[items.plasma] + balance.total.eu / recipes.plasma_energy.items.eu
  --the energy reserve is calculated for a running reactor with all currently enabled machines
  if not reactor.running then
   --include reactor's costs
   storage = math.max(storage - recipe.initial / recipes.plasma_energy.items.eu, 0)
   balance = balance + (recipe.rate[items.plasma] or 0) + recipe.rate.eu / recipes.plasma_energy.items.eu
  end
  if balance > 0 then
   return "infinite"
  end
  return -storage / balance / recipe.ticks
 end
end, 125, 11)
---pipes / cables
image(import("images/pipes_input_east.txt"), 21, 10).color = function()
 return uicolors.pipe[reactor.input_east.tank.type or "default"]
end
image(import("images/pipes_input_west.txt"), 21, 20).color = function()
 return uicolors.pipe[reactor.input_west.tank.type or "default"]
end
image(import("images/pipes_deuterium.txt"), 48, 19).color = function()
 local color = uicolors.pipe.default
 if availability[items.deuterium] then
  color = uicolors.pipe[items.deuterium]
 end
 return color
end
image(import("images/pipes_tritium.txt"), 48, 13).color = function()
 local color = uicolors.pipe.default
 if availability[items.tritium] then
  color = uicolors.pipe[items.tritium]
 end
 return color
end
image(import("images/pipes_hydrogen_from_electrolyzers.txt"), 75, 35).color = function()
 local color = uicolors.pipe.default
 if availability[items.hydrogen] then
  color = uicolors.pipe[items.hydrogen]
 end
 return color
end
image(import("images/pipes_hydrogen_from_tank.txt"), 93, 35).color = function()
 local color = uicolors.pipe.default
 if availability[items.hydrogen] then
  color = uicolors.pipe[items.hydrogen]
 end
 if not machines.centrifuges.hydrogen then
  color = uicolors.pipe.default
 end
 return color
end
image(import("images/pipes_water.txt"), 60, 37).color = color(0x4444FF,0x000000)

local function sufficientEnergy()
 return generators.rate.eu >= machines.rate.eu
end

image(import("images/eu_cables.txt"), 41, 35).color = function()
 local color = uicolors.pipe.default
 if sufficientEnergy() then
  color = uicolors.pipe.energy
 elseif generators.rate.eu > 0 then
  color = uicolors.pipe.lowEnergy
 end
 return color
end


---machines
local function machine_color(running)
 return function()
  local color = uicolors.machine.disabled
  if running() then
   if sufficientEnergy() then
    color = uicolors.machine.enabled
   else
    color = uicolors.machine.error
   end
  end
  return color
 end
end


local gen_positions = {
 {48,  40},
 {48,  36},
 {42,  36},
 {42,  40},
}
local gen_image = import("images/generator.txt")

for index, pos in ipairs(gen_positions) do
 image(gen_image, pos[1], pos[2]).color = machine_color(function()
  return generators[index].running
 end)
end

local el_positions = {
 {75,  36},
}
local el_image = import("images/electrolyzer.txt")

for index, pos in ipairs(el_positions) do
 image(el_image, pos[1], pos[2]).color = machine_color(function()
  return machines.electrolyzers[index].running
 end)
end

local cen_positions = {
 {97,  41},
 {103, 41},
 {109, 41},
 {109, 35},
 {103, 35},
 {97,  35},
}
local cen_image = import("images/centrifuge.txt")

for index, pos in ipairs(cen_positions) do
 local cen = machines.centrifuges[index]
 local enabledTable = {dt = true}
 if cen.recipe == recipes.centrifuge_deuterium then
  enabledTable.d = true
 else
  enabledTable.t = true
 end
 image(cen_image, pos[1], pos[2]).color = machine_color(function()
  return cen.enabled or enabledTable[reactor.deuterium_distribution]
 end)
end

image(import("images/reactor.txt"), 79, 11).color = function()
 if reactor.running then
  return uicolors.machine.enabled
 else
  return uicolors.machine.disabled
 end
end


---labels

