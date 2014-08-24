-- Item-Definitionen.
local items = {
  cells = {
    name = "Empty Cells",
    id = 30237,
    damage = 0,
  },
  hydrogen = {
    name = "Hydrogen",
    id = 9583,
    damage = 0,
    fluid = 22
  },
  deuterium = {
    name = "Deuterium",
    id = 9583,
    damage = 1,
    fluid = 111
  },
  tritium = {
    name = "Tritium",
    id = 9583,
    damage = 2,
    fluid = 112
  },
  helium3 = {
    name = "Helium-3",
    id = 9583,
    damage = 6,
    fluid = 114
  },
  plasma = {
    name = "Helium Plasma",
    id = 9583,
    damage = 131,
    fluid = 110
  },
  wolframium = {
    name = "Wolframium",
    id = 9583,
    damage = 4,
    fluid = 118
  },
  berylium = {
    name = "Berylium",
    id = 9583,
    damage = 10,
    fluid = 121
  },
  lithium = {
    name = "Lithium",
    id = 9583,
    damage = 5,
    fluid = 119
  },
  iridium = {
    name = "Iridium",
    id = 30128,
    damage = 0
  },
  platinum = {
    name = "Platinum",
    id = 20264,
    damage = 37
  },
}

-- Bilde LUTs, um das finden von Items anhad ihrer ID zu erleichtern
local itemIdLUT = {}
local fluidIdLUT = {}

for _, item in pairs(items) do
  local dmgLUT = itemIdLUT[item.id]
  if not dmgLUT then
    dmgLUT = {}
    itemIdLUT[item.id] = dmgLUT
  end
  
  dmgLUT[item.damage] = item
  
  if item.fluid then
    fluidIdLUT[item.fluid] = item
  end
end

function items.fromFluidId(id)
  return id and fluidIdLUT[id]
end

function items.fromId(id, damage)
  local dmgLUT = id and itemIdLUT[id]
  return dmgLUT and dmgLUT[damage or 0]
end

return items