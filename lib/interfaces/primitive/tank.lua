--[[
 file: tank.lua
 description:
  basic tank access
]]


local items = require 'data.items'
local component = require 'component'

return function(address)
  return function()
    local ti = component.invoke(address, "getTankInfo")
    return { type = items.fromFluidId(ti.id), amount = ti.amount / 1000.0, capacity = ti.capacity }
  end
end