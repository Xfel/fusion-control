--[[
 file: me.lua
 description:
  This file creates all applied energistics getter.
]]


local data = require 'data.interfaces'
local component = require 'component'
local items = require 'data.items'
local properties = require 'interfaces.properties'

-- erzeugt eine Funktion, die die Menge an items des gegebenen typs ausliest.
local function aeRead(address, item)
  return function()
    return component.invoke(address, "countOfItemType", item.id, item.damage)
  end
end

--generate getter table
local t = {}
for name, item in pairs(items) do
 if type(item) == "table" then
  local aeAccess = aeRead(data.ae, item)
  t[name] = aeAccess --'direct' access (via name)
  t[item] = aeAccess --'indirect' access (via item type)
 end
end
--wrap getters
return properties(t)