tank      ("tanks.helium3",       14, 12)
tank      ("tanks.tritium",       33, 12)
tank      ("tanks.wolframium",    52, 12)
tank      ("tanks.lithium",       14, 18)
tank      ("tanks.deuterium",     33, 18)
tank      ("tanks.berylium",      52, 18)
tank      ("tanks.plasma",       123, 15)
tank_small("reactor.input_east",  80,  6, "Input East")
tank_small("reactor.input_west",  80, 24, "Input West")
production("reactor.recipe",      98, 19, "Producing")
me        ("items.helium3",       20, 26)
me        ("items.tritium",       20, 28)
me        ("items.deuterium",     20, 30)
me        ("items.lithium",       34, 26)
me        ("items.berylium",      34, 28)
me        ("items.wolframium",    34, 30)
me        ("items.cells",         56, 49)
me        ("items.hydrogen",      86, 49)
me        ("items.iridium",      126, 23)
me        ("items.platinum",     126, 25)
eu        ("(reactor.recipe or {}).initial", 99, 9)
eu        ("reactor.computer.energy",        99, 7)
percentage([[(function()
 local current = reactor.computer.energy
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
]], 105, 11).color = color(0xFFFFFF,0x000000)
equation  ("(reactor.recipe or {}).equation", 125, 7)
cycles    ([[(function()
 local recipe = reactor.recipe
 if recipe then
  local cycles = math.huge
  for _, ingredient in ipairs(recipe.ingredients) do
   print(ingredient.name)
   cycles = math.min(cycles, tanks[ingredient].tank.amount)
  end
  return cycles
 end
end)()]], 125, 9)
