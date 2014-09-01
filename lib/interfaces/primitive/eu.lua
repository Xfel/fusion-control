--[[
 file: eu.lua
 description:
  basic energy storage access
]]

local component = require 'component'

return function(address)
  return function()
    return component.invoke(address, "getStored")
  end
end