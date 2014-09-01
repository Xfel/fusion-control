--[[
 file: addresses.lua
 description:
  contains raw interface data (e.g. addresses)
  The interface modules fill this data with life. (e.g. by providing access to the tank with the given address)
]]

local items = require 'data.items'
local recipes = require 'data.recipes'
local sides = require 'sides'

return {
 screen = {
  control = "de88ee46-c992-440e-9d1c-677c98bc274b",
  monitoring = "9e72c4d1-1007-4fe9-8fe5-5e095a9e417f",
 },
 gpu = {
  control = "75a3c337-d529-466a-aa0a-8fcccca3e338",
  monitoring = "63aed535-4aab-44cc-a22b-6b8a310cd9bd",
 },
 keyboard = {
  control = "TODO",
 },
 ae = "dffb6dd3-ca32-4240-9ea8-aa8952e52691",
 tanks = {
  plasma = {
   tank = "9ab20ca1-7486-4ad1-a68e-948f56924380",
   item = items.plasma,
   redstone = {
    output_reactor = {"b9501797-21cb-4f8c-81db-1882aaec8a97", sides.west},
    output_generators = {"b9501797-21cb-4f8c-81db-1882aaec8a97", sides.north},
    output_export = {"b9501797-21cb-4f8c-81db-1882aaec8a97", sides.east},
   },
   mixed = false,
   limited = "output_export",
  },
  deuterium = {
   tank = "cce5cf42-0bcb-47fd-b1fc-3751114477bb",
   item = items.deuterium,
   redstone = {
    input = {"d1259a71-fca5-40e4-9f07-c3f1be6f7f05", sides.west},
    output = {"d1259a71-fca5-40e4-9f07-c3f1be6f7f05", sides.up},
   },
   mixed = true,
  },
  tritium = {
   tank = "1ca2e683-0a98-48a5-addd-f0bd07afe426",
   item = items.tritium,
   redstone = {
    output = {"eb4c8876-01a6-4bdd-9432-9bebac365076", sides.up},
   },
   mixed = true,
  },
  helium3 = {
   tank = "723a7ca7-5b82-46cc-8dd9-f4603074a0b1",
   item = items.helium3,
   redstone = {
    output = {"acac1089-5ca5-48fe-bb60-c8cfb0d6072a", sides.up},
   },
   mixed = true,
  },
  wolframium = {
   tank = "14e7b8a1-dede-46ef-b1bc-3db9c4b0e5be",
   item = items.wolframium,
   redstone = {
    output = {"14c8d101-0b49-406e-afdf-e857bc81231c", sides.up},
   },
   mixed = true,
  },
  lithium = {
   tank = "cf9b590e-5432-407d-b6cb-131f1fce4824",
   item = items.lithium,
   redstone = {
    output = {"ba43f8c8-0d60-4326-9a54-3fd28460cbb7", sides.up},
   },
   mixed = true,
  },
  berylium = {
   tank = "d82702a8-ad9a-45de-ba28-94639053bd19",
   item = items.berylium,
   redstone = {
    output = {"22caf96b-fbd6-4c2e-a442-891bd5ee3e94", sides.up},
   },
   mixed = true,
  },
 },
 reactor = {
  redstone = {
   enabled = {"703394c3-f38b-466a-babf-683f17b71d38", sides.up, nil, "inverted"},
   primer = ["d2073569-b179-48fe-a44c-01845b6bf710", sides.east, nil, "inverted"},
  },
  energy = "7e5a3837-9cf2-4998-b447-92cd1b83868d",
  input_east = {
   tank = "9e1ba28a-c19a-4a38-bdad-5bf2b306672a",
   redstone = {
    recycle = {"a96c0f67-45d5-47e3-ae84-956107425a05", sides.up},
   },
  },
  input_west = {
   tank = "60e72361-042a-4848-90fe-3f3f73db6879",
   redstone = {
    recycle = {"5ffa5a21-3b68-4d43-88bd-afb5b29a93bf", sides.up},
   },
  },
  generators = {
   [1]={
    recipe = recipes.plasma_energy,
    requirement = "tanks.plasma.output_generators",
    redstone = {
     enabled = {"124a5dc1-45e8-430f-9f69-80f3c7b53388", sides.west},
    },
   },
   [2]={
    recipe = recipes.plasma_energy,
    requirement = "tanks.plasma.output_generators",
    redstone = {
     enabled = {"124a5dc1-45e8-430f-9f69-80f3c7b53388", sides.south},
    },
   },
   [3]={
    recipe = recipes.plasma_energy,
    requirement = "tanks.plasma.output_generators",
    redstone = {
     enabled = {"124a5dc1-45e8-430f-9f69-80f3c7b53388", sides.east},
    },
   },
   [4]={
    recipe = recipes.plasma_energy,
    requirement = "tanks.plasma.output_generators",
    redstone = {
     enabled = {"124a5dc1-45e8-430f-9f69-80f3c7b53388", sides.north},
    },
   },
  },
  machines = {
   centrifuges = {
    redstone = {
     hydrogen  = {"64859669-a8b4-4dd2-97be-2f311f91f261", sides.north},
     deuterium = {"abcf2e38-dcb7-41cf-b664-664f45ce4ebc", sides.south},
    },
    [1] = {
     recipe = recipes.centrifuge_deuterium,
     requirement = "machines.centrifuges.hydrogen"
     redstone = {
      enabled = {"f7018da2-3a0c-4a05-a141-78e5c6098179", sides.up, nil, "inverted"},
     },
    },
    [2] = {
     recipe = recipes.centrifuge_deuterium,
     requirement = "machines.centrifuges.hydrogen"
     redstone = {
      enabled = {"0ee7845b-1297-4d3e-b663-70fe0b25a3bb", sides.up, nil, "inverted"},
     },
    },
    [3] = {
     recipe = recipes.centrifuge_deuterium,
     requirement = "machines.centrifuges.hydrogen"
     redstone = {
      enabled = {"dabe4239-5a25-4138-91a0-c1b43f7b6919", sides.up, nil, "inverted"},
     },
    },
    [4] = {
     recipe = recipes.centrifuge_deuterium,
     requirement = "machines.centrifuges.hydrogen"
     redstone = {
      enabled = {"526b976e-4c91-4168-b743-ce1f045df8cb", sides.up, nil, "inverted"},
     },
    },
    [5] = {
     recipe = recipes.centrifuge_deuterium,
     requirement = "machines.centrifuges.hydrogen"
     redstone = {
      enabled = {"64859669-a8b4-4dd2-97be-2f311f91f261", sides.up, nil, "inverted"},
     },
    },
    [6] = {
     recipe = recipes.centrifuge_tritium,
     requirement = "machines.centrifuges.deuterium"
     redstone = {
      enabled = {"abcf2e38-dcb7-41cf-b664-664f45ce4ebc", sides.up, nil, "inverted"},
     },
    },
   },
   electrolyzers = {
    redstone = {
     cells  = {"8345d5c0-78e4-4e05-99bd-e817ac977252", sides.west, nil, "inverted"},
    },
    [1] = {
     recipe = recipes.electrolyzer_hydrogen,
     requirement = "machines.electrolyzers.cells",
     redstone = {
      enabled = {"8345d5c0-78e4-4e05-99bd-e817ac977252", sides.north, nil, "inverted"},
     },
    },
  },
 },

}