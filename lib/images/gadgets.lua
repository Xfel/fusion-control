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
local balance_output = "(reactor.output.type == items.plasma and reactor.output.rate or 0)"
local balance_reactor = "reactor.rate / recipes.plasma_energy.total"
local balance_machines = "machines.rate / recipes.plasma_energy.total"
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
energy_balance("machines.electrolyzers.rate", 21, 38)
energy_balance("machines.centrifuges.rate",   21, 40)
energy_balance("machines.rate",   21, 42)
energy_balance("generators.rate", 21, 47)
---recipe information
equation  ("(reactor.recipe or {}).equation", 125, 7)
cycles(function()
 local recipe = reactor.recipe
 if recipe then
  local cycles = math.huge
  for _, ingredient in ipairs(recipe.ingredients) do
   local tank = tanks[ingredient].tank
   local thisReserve = tank.amount / 1000.0
   cycles = math.min(cycles, thisReserve)
  end
  return cycles
 end
end, 125, 9)
cycles(function()
 local recipe = reactor.recipe
 if recipe then
  local storage = tanks.plasma.tank.amount + reactor.energy / recipes.plasma_energy.total
  if not reactor.enabled then
   storage = math.max(storage - recipe.inital / recipes.plasma_energy.total, 0)
  end
  local balance = (machines.rate + recipe.rate) / recipes.plasma_energy.total
  if recipe.result == items.plasma then
   balance = balance + 1 / recipe.ticks
  end
  if balance > 0 then
   return "infinite"
  end
  return -storage / balance / recipe.ticks
 end
end, 125, 11)
