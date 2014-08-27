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
production("reactor.recipe",      98, 19, "Producing")
local balance_output = "(reactor.output.type == items.plasma and reactor.output.rate or 0)"
local balance_reactor = "reactor.rate / recipes.plasma_energy.total"
local balance_machines = "machines.rate / recipes.plasma_energy.total"
fluid_balance(balance_output, 125, 37)
fluid_balance(balance_reactor, 125, 39)
fluid_balance(balance_machines, 125, 41)
fluid_balance(balance_output .. "+" .. balance_reactor .. "+" .. balance_machines, 125, 43)
---items
item      ("items.helium3",       20, 26)
item      ("items.tritium",       20, 28)
item      ("items.deuterium",     20, 30)
item      ("items.lithium",       34, 26)
item      ("items.berylium",      34, 28)
item      ("items.wolframium",    34, 30)
item      ("items.cells",         56, 49)
item      ("items.hydrogen",      86, 49)
item      ("items.iridium",      126, 23)
item      ("items.platinum",     126, 25)
---energy
--storage
energy    ("(reactor.recipe or {}).initial", 99, 9)
energy    ("reactor.energy",      99, 7)
percentage([[(function()
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
end)()
]], 105, 11)
--rate
energy_balance("machines.electrolyzers.rate", 22, 38)
energy_balance("machines.centrifuges.rate",   22, 40)
energy_balance("machines.rate",   22, 42)
energy_balance("generators.rate", 22, 47)
---recipe information
equation  ("(reactor.recipe or {}).equation", 125, 7)
cycles    ([[(function()
 local recipe = reactor.recipe
 if recipe then
  local cycles = math.huge
  for _, ingredient in ipairs(recipe.ingredients) do
   cycles = math.min(cycles, tanks[ingredient].tank.amount / 1000.0)
  end
  return cycles
 end
end)()]], 125, 9)
