--[[
 file: quicksum.lua
 description:
  a generic sum function
]]

return function(list, property, iterator)
 local sum
 for _, object in iterator(list) do
  if type(object) == "table" then
   local value = object[property]
   if value then
    if sum then
     sum = sum + value
    else
     sum = value
    end
   end
  end
 end
 return sum
end