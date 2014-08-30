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
  total = -2048 * 128,
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
  total = -4096 * 128,
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
  total = -32768 * 512,
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
  total = -32768 * 512,
  result = items.platinum,
  equation = "W + Be   -> Pt",
 },
 electrolyzer_hydrogen = {
  ingredients = {
   items.cells
   --water is automaticly inserted
  },
  initial = 0,
  rate = -6360,
  ticks = 6.25,
  total = -6360 * 6.25,
  result = items.hydrogen,
  equation = "2 H2O -> 2 H2 + O2",
 },
 centrifuge_deuterium = {
  ingredients = {
   items.hydrogen,
   items.hydrogen,
   items.hydrogen,
   items.hydrogen,
  },
  initial = 0,
  rate = -268, --11x 20 EU/t and 1x 80 EU/t - 32 EU/t RTG generation
  ticks = 1500 / 13, --11x 1500 ticks and 1x 750 ticks => 13x 1500 ticks
  total = -268 * 1500 / 13,
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
  rate = -268, --11x 20 EU/t and 1x 80 EU/t - 32 EU/t RTG generation
  ticks = 1500 / 13, --11x 1500 ticks and 1x 750 ticks => 13x 1500 ticks
  total = -268 * 1500 / 13,
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
  total = 2048 * 2000,
  result = nil,
  equation = "He -> energy",
 },
}

return recipes