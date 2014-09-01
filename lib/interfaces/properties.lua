--[[
 file: properties.lua
 description:
  contains a helper function, which generates a table with a metatable
  the metatable __index / __newindex functions use the given parameter as a source for getter and setter functions
  TODO: The results are cached; the cache is reset every X seconds or by a method
]]


--TODO: caching for properties, set __newindex metatable to pTable to catch extensions (maybe)
-- einige hilfsfunktionen
-- generiert eine Metatable, die entsprechende Getter/Setter-Funktionen in __index/__newindex nutzt.
return function properties(pTable, dTable)
  -- normalize
  for k, prop in pairs(pTable) do
    --TODO: quick getters (maybe)
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