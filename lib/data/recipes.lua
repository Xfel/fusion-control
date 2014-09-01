-- imports
local items = require 'data.items'
local newRate = require 'data.newRate'

-- Rezept-Definitionen
local recipes = {
 fusion_d_he3 = {
  items = {
   [items.deuterium] = -1,
   [items.helium3] = -1,
   [items.plasma] = 1,
   eu = -2048 * 128,
  },
  initial = 60000000,
  ticks = 128,
  equation = "D + He-3 -> He",
 },
 fusion_d_t = {
  items = {
   [items.deuterium] = -1,
   [items.tritium] = -1,
   [items.plasma] = 1,
   eu = -4096 * 128,
  },
  initial = 40000000,
  ticks = 128,
  equation = "D + T    -> He",
 },
 fusion_w_li = {
  items = {
   [items.wolframium] = -1,
   [items.lithium] = -1,
   [items.iridium] = 1,
   eu = -32768 * 512,
  },
  initial = 150000000,
  ticks = 512,
  equation = "W + Li   -> Ir",
 },
 fusion_w_be = {
  items = {
   [items.wolframium] = -1,
   [items.berylium] = -1,
   [items.platinum] = 1,
   eu = -32768 * 512,
  },
  initial = 100000000,
  ticks = 512,
  equation = "W + Be   -> Pt",
 },
 electrolyzer_hydrogen = {
  items = {
   [items.cells] = -1,
   [items.hydrogen] = 1,
   eu = -6360 * 6.25,
   --water is automaticly inserted
  },
  initial = 0,
  ticks = 6.25,
  equation = "2 H2O -> 2 H2 + O2",
 },
 centrifuge_deuterium = {
  items = {
   [items.hydrogen] = -4,
   [items.deuterium] = 1,
   eu = -268 * 1500 / 13,
  },
  initial = 0,
  ticks = 1500 / 13, --11x 1500 ticks and 1x 750 ticks => 13x 1500 ticks
  equation = "4 H -> D",
 },
 centrifuge_tritium = {
  items = {
   [items.deuterium] = -4,
   [items.tritium] = 1,
   eu = -268 * 1500 / 13,
  },
  initial = 0,
  ticks = 1500 / 13, --11x 1500 ticks and 1x 750 ticks => 13x 1500 ticks
  equation = "4 D -> T",
 },
 plasma_energy = {
  items = {
   [items.plasma] = -1,
   eu = 2048 * 2000,
  },
  initial = 0,
  ticks = 2000,
  equation = "He -> energy",
 },
}

for _, recipe in pairs(recipes) do
 local rate = newRate()
 local ticks = recipe.ticks
 for item, amount in pairs(recipe.items) do
  rate[item] = amount / ticks
 end
 recipe.rate = rate
end

return recipes