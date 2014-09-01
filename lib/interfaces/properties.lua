--[[
 file: properties.lua
 description:
  contains a helper function, which generates a table with a metatable
  the metatable __index / __newindex functions use the given parameter as a source for getter and setter functions
  TODO: The results are cached; the cache is reset every X seconds or by a method
]]
local caches = setmetatable({},{__mode = "k"})
local function resetCaches()
 for k,_ in pairs(caches) do
  caches[k] = {}
 end
end
require('event').timer(3.0, resetCaches, math.huge)


--TODO: caching for properties, set __newindex metatable to pTable to catch extensions (maybe)
-- einige hilfsfunktionen
-- generiert eine Metatable, die entsprechende Getter/Setter-Funktionen in __index/__newindex nutzt.
return function(pTable, dTable)
  -- normalize
  for k, prop in pairs(pTable) do
    --TODO: quick getters (maybe)
    if type(prop) == "function" then
      pTable[k] = {get=prop}
    end
  end
  
  local dTable = dTable or {}
  caches[pTable] = {}
  
  return setmetatable(dTable or {}, {
    __index = function(t, k)
      --1st: try cache
      local cache = caches[pTable]
      local cachedValue = cache[k]
      if cachedValue ~= nil then
        return cachedValue
      end
      --2nd: try property
      local pt = pTable[k]
      if pt and pt.get then
        --2.5th: save value
        cachedValue = pt.get()
        cache[k] = cachedValue
        return cachedValue
      end
      
      error("No such readable property '"..k.."'",2)
    end,
    
    __newindex = function(t, k, v)
      local cache = caches[pTable]
      local pt = pTable[k]
      
      if pt and pt.set then
        cache[k] = nil --reset cache
        return pt.set(v)
      end
      
      error("No such writable property '"..k.."'",2)
    end,
  })
end