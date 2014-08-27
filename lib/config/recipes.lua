-- imports
local items = require 'config.items'

-- Rezept-Definitionen
local recipes = {
 fusion_d_he3 = {
  ingredients = {
   items.deuterium,
   items.helium3,
  },
  initial = 60000000,
  rate = -2048,
  ticks = 128,
  total = -2048*128,
  result = items.plasma,
  equation = "D + He-3 -> He",
 },
 fusion_d_t = {
  ingredients = {
   items.deuterium,
   items.tritium,
  },
  initial = 40000000,
  rate = -4096,
  ticks = 128,
  total = -4096*128,
  result = items.plasma,
  equation = "D + T    -> He",
 },
 fusion_w_li = {
  ingredients = {
   items.wolframium,
   items.lithium,
  },
  initial = 150000000,
  rate = -32768,
  ticks = 512,
  total = -32768*512,
  result = items.iridium,
  equation = "W + Li   -> Ir",
 },
 fusion_w_be = {
  ingredients = {
   items.wolframium,
   items.berylium,
  },
  initial = 100000000,
  rate = -32768,
  ticks = 512,
  total = -32768*512,
  result = items.platinum,
  equation = "W + Be   -> Pt",
 },
 centrifuge_deuterium = {
  ingredients = {
   items.hydrogen,
   items.hydrogen,
   items.hydrogen,
   items.hydrogen,
  },
  initial = 0,
  rate = -20,
  ticks = 1500,
  total = -20*1500,
  result = items.deuterium,
  equation = "4 H -> D",
 },
 centrifuge_tritium = {
  ingredients = {
   items.deuterium,
   items.deuterium,
   items.deuterium,
   items.deuterium,
  },
  initial = 0,
  rate = -20,
  ticks = 1500,
  total = -20*1500,
  result = items.tritium,
  equation = "4 D -> T",
 },
 plasma_energy = {
  ingredients = {
   items.plasma
  },
  initial = 0,
  rate = 2048,
  ticks = 2000,
  total = 2048*2000,
  result = nil,
  equation = "He -> energy",
 },
}

return recipes