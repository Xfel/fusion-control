--[[
 file: quickrs.lua
 description:
  simplifies the creation of redstone controls by creating a list of redstone properties from a list of addresses + other data
]]

return function(props, rsData)
 if rsData then
  for name, rsTable in pairs(rsData) do
   props[name] = redstone(table.unpack(rsTable, 1, 4))
  end
 end
 return props
end