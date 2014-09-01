--[[
 file: eu.lua
 description:
  basic energy storage access
]]

return function(address)
  return function()
    return component.invoke(address, "getStored")
  end
end