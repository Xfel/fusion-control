-- imports
local component = require 'component'
local sides = require 'sides'
local colors = require 'colors'
local items = require 'config.items'
local recipes = require 'config.recipes'
local mixer = require 'config.mixer'
local distributor = require 'config.distributor'

-- einige hilfsfunktionen
-- generiert eine Metatable, die entsprechende Getter/Setter-Funktionen in __index/__newindex nutzt.
local function properties(pTable, dTable)
  -- normalize
  for k, prop in pairs(pTable) do
    if type(prop) == "function" then
      pTable[k] = {get=prop}
    end
  end
  return setmetatable(dTable or {}, {
    __index = function(t, k)
      local pt = pTable[k]
      
      if pt and pt.get then
        return pt.get()
      end
      
      error("No such readable property '"..k.."'",2)
    end,
    
    __newindex = function(t, k, v)
      local pt = pTable[k]
      
      if pt and pt.set then
        return pt.set(v)
      end
      
      error("No such writable property '"..k.."'",2)
    end,
  })
end

-------------------------- REDSTONE --------------------------
-- small xor function
local function xor(a,b)
 if a then
  return not b
 elseif b then
  return true
 else
  return false
 end
end

-- erzeugt eine Funktion, die den redstone-Status an der gegebenen stelle liest. Die funktion gibt true oder false zurück.
local function rsBRead(address, side, color, inverted)
  if color then
    return function()
      return xor(component.invoke(address, "getBundledInput", side, color) > 0, inverted)
    end
  else
    return function()
      return xor(component.invoke(address, "getInput", side) > 0, inverted)
    end
  end
end

-- erzeugt eine Funktion, die den redstone-Status an der gegebenen stelle schreibt. Die funktion akzeptiert true oder false.
local function rsBWrite(address, side, color, inverted)
  if color then
    return function(val)
      val = xor(val, inverted)
      -- normalize
      if val == true then
        val = 15
      elseif val == false then
        val = 0
      end
      
      component.invoke(address, "setBundledOutput", side, color, val)
    end
  else
    return function(val)
      val = xor(val, inverted)
      -- normalize
      if val == true then
        val = 15
      elseif val == false then
        val = 0
      end
      
      component.invoke(address, "setOutput", side, val)
    end
  end
end

local function rsBProp(address, side, color, inverted)
  return { 
    get = rsBRead(address, side, color, inverted), 
    set = rsBWrite(address, side, color, inverted),
  }
end

-------------------------- APPLIED ENERGISTICS --------------------------
-- erzeugt eine Funktion, die die Menge an items des gegebenen typs ausliest.
function aeRead(address, item)
  return function()
    return component.invoke(address, "countOfItemType", item.id, item.damage)
  end
end

-------------------------- FLUID TANKS --------------------------

function ftiRead(address)
  return function()
    local ti = component.invoke(address, "getTankInfo")
    
    return { type=items.fromFluidId(ti.id), amount=ti.amount, capacity=ti.capacity }
  end
end

function ftiAmountRead(address)
  return function()
    return component.invoke(address, "getTankInfo").amount
  end
end

function ftiTypeRead(address)
  return function()
    return items.fromFluidId(component.invoke(address, "getTankInfo").id)
  end
end

-------------------------- ENERGY --------------------------
function euRead(address)
  return function()
    return component.invoke(address, "getStored")
  end
end

-------------------------- MACHINES ------------------------
function centrifuge(redstone_address, recipe)
 local cen
 cen = properties({
  energy = rsBProp(redstone_address, sides.up, nil, "inverted"),
  enabled = function()
   return cen.energy
  end,
  rate = function()
   if cen.enabled then
    return -300
   else
    return 0
   end
  end,
  recipe = recipe,
  count = 12,
 })
 return cen
end
function electrolyzer(redstone_address)
 local el
 el = properties({
  energy = rsBProp(redstone_address, sides.north, nil, "inverted"),
  enabled = function()
   return el.energy
  end,
  rate = function()
   if el.enabled then
    return -5880
   else
    return 0
   end
  end,
 
 })
end

--------------------------- SCREEN -------------------------
function screen(screen_address, gpu_address)
 local gpu=component.proxy(gpu_address)
 gpu.bind(screen_address)
 return gpu
end




-- eigentliche interfacedefs
local aeTeminalId = "dffb6dd3-ca32-4240-9ea8-aa8952e52691"
local interfaces
interfaces = {
  -- Maschinen
  machines = {
    electrolyzer = properties({
      cells  = rsBProp("8345d5c0-78e4-4e05-99bd-e817ac977252", sides.west),
      function rate()
       return interfaces.electrolyzer[1].rate
      end,
     },{
      [1] = electrolyzer("8345d5c0-78e4-4e05-99bd-e817ac977252"),
    }),
    centrifuges = properties({
      hydrogen  = rsBProp("64859669-a8b4-4dd2-97be-2f311f91f261", sides.north),
      deuterium = rsBProp("abcf2e38-dcb7-41cf-b664-664f45ce4ebc", sides.south),
      rate = function()
       local sum = 0
       for _,cen in ipairs(interfaces.centrifuges) do
        sum = sum + cen.rate
       end
       return sum
      end,
     },{
      [1] = centrifuge("f7018da2-3a0c-4a05-a141-78e5c6098179", recipes.centrifuge_deuterium),
      [2] = centrifuge("0ee7845b-1297-4d3e-b663-70fe0b25a3bb", recipes.centrifuge_deuterium),
      [3] = centrifuge("dabe4239-5a25-4138-91a0-c1b43f7b6919", recipes.centrifuge_deuterium),
      [4] = centrifuge("526b976e-4c91-4168-b743-ce1f045df8cb", recipes.centrifuge_deuterium),
      [5] = centrifuge("64859669-a8b4-4dd2-97be-2f311f91f261", recipes.centrifuge_deuterium),
      [6] = centrifuge("abcf2e38-dcb7-41cf-b664-664f45ce4ebc", recipes.centrifuge_tritium),
    }),
  },
  
  --alle Reaktorkomponenten
  reactor = {
    computer = properties({
      energy = euRead("7e5a3837-9cf2-4998-b447-92cd1b83868d"),
      enabled = rsBProp("703394c3-f38b-466a-babf-683f17b71d38", sides.up, nil, "inverted"),
      rate = function()
       local recipe=interfaces.reactor.recipe
       if recipe and enabled then
        return recipe.rate
       end
       return 0
      end,
    }),
    input_west = properties({
      tank    = ftiRead("60e72361-042a-4848-90fe-3f3f73db6879"),
      recycle = rsBProp("5ffa5a21-3b68-4d43-88bd-afb5b29a93bf",sides.up),
    }),
    input_east = properties({
      tank    = ftiRead("9e1ba28a-c19a-4a38-bdad-5bf2b306672a"),
      recycle = rsBProp("a96c0f67-45d5-47e3-ae84-956107425a05",sides.up),
    }),
  },



  --alle Tanks
  tanks = {
    plasma = properties({
      tank              = ftiRead("9ab20ca1-7486-4ad1-a68e-948f56924380"),
      output_reactor    = rsBProp("b9501797-21cb-4f8c-81db-1882aaec8a97",sides.west),
      output_generators = rsBProp("b9501797-21cb-4f8c-81db-1882aaec8a97",sides.north),
      output_export     = rsBProp("b9501797-21cb-4f8c-81db-1882aaec8a97",sides.east),
    },{
      mixed             = false,
      item              = items.plasma
    }),
    ---fuel
    --energy producing
    deuterium = properties({
      tank   = ftiRead("cce5cf42-0bcb-47fd-b1fc-3751114477bb"),
      output = rsBProp("d1259a71-fca5-40e4-9f07-c3f1be6f7f05", sides.up),
      input  = rsBProp("d1259a71-fca5-40e4-9f07-c3f1be6f7f05", sides.west),
    },{
      mixed  = true,
      item   = items.deuterium,
    }),
    tritium = properties({
      tank   = ftiRead("1ca2e683-0a98-48a5-addd-f0bd07afe426"),
      output = rsBProp("eb4c8876-01a6-4bdd-9432-9bebac365076",sides.up),
    },{
      mixed  = true,
      item   = items.tritium,
    }),
    helium3 = properties({
      tank   = ftiRead("723a7ca7-5b82-46cc-8dd9-f4603074a0b1"),
      output = rsBProp("acac1089-5ca5-48fe-bb60-c8cfb0d6072a",sides.up),
    },{
      mixed  = true,
      item   = items.helium3,
    }),
    --matter producing
    wolframium = properties({
      tank   = ftiRead("14e7b8a1-dede-46ef-b1bc-3db9c4b0e5be"),
      output = rsBProp("14c8d101-0b49-406e-afdf-e857bc81231c",sides.up),
    },{
      mixed  = true,
      item   = items.wolframium,
    }),
    berylium = properties({
      tank   = ftiRead("d82702a8-ad9a-45de-ba28-94639053bd19"),
      output = rsBProp("22caf96b-fbd6-4c2e-a442-891bd5ee3e94",sides.up),
    },{
      mixed  = true,
      item   = items.berylium,
    }),
    lithium = properties({
      tank   = ftiRead("cf9b590e-5432-407d-b6cb-131f1fce4824"),
      output = rsBProp("ba43f8c8-0d60-4326-9a54-3fd28460cbb7",sides.up),
    },{
      mixed  = true,
      item   = items.lithium,
    }),
  },
  --items im ME-System
  items = properties({
   cells      = aeRead(aeTeminalId,items.cells),
   hydrogen   = aeRead(aeTeminalId,items.hydrogen),
   deuterium  = aeRead(aeTeminalId,items.deuterium),
   tritium    = aeRead(aeTeminalId,items.tritium),
   
   helium3    = aeRead(aeTeminalId,items.helium3),
   
   wolframium = aeRead(aeTeminalId,items.wolframium),
   lithium    = aeRead(aeTeminalId,items.lithium),
   berylium   = aeRead(aeTeminalId,items.berylium),
   iridium    = aeRead(aeTeminalId,items.iridium),
   platinum   = aeRead(aeTeminalId,items.platinum),
  }),
  --4 Generatoren
  generators = {
    [1] = properties({
      enabled = rsBProp("124a5dc1-45e8-430f-9f69-80f3c7b53388",sides.west),
      rate    = 2048,
    }),
    [2] = properties({
      enabled = rsBProp("124a5dc1-45e8-430f-9f69-80f3c7b53388",sides.south),
      rate    = 2048,
    }),
    [3] = properties({
      enabled = rsBProp("124a5dc1-45e8-430f-9f69-80f3c7b53388",sides.east),
      rate    = 2048,
    }),
    [4] = properties({
      enabled = rsBProp("124a5dc1-45e8-430f-9f69-80f3c7b53388",sides.north),
      rate    = 2048,
    }),
  },
  screens = {
    control = screen("2de88ee46-c992-440e-9d1c-677c98bc274b", "75a3c337-d529-466a-aa0a-8fcccca3e338"),
    monitoring = screen("9e72c4d1-1007-4fe9-8fe5-5e095a9e417f", "63aed535-4aab-44cc-a22b-6b8a310cd9bd"),
  },
}

interfaces.reactor = properties({
 recipe = mixer(
  interfaces.tanks,
  {
   interfaces.reactor.input_east,
   interfaces.reactor.input_west,
  }
 ),
 deuterium_distribution = distributor(
  interfaces.tanks.deuterium,
  interfaces.tanks.tritium,
  interfaces.machines.centrifuges
 ),
 primer = rsBProp("d2073569-b179-48fe-a44c-01845b6bf710", sides.east, nil, "inverted"),
}, interfaces.reactor)


return interfaces