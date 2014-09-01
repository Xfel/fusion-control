--[[
 file: screens.lua
 description:
  creates an interface for every screen listed in the data.interfaces file
]]


local data = require 'data.interfaces'
local component = require 'component'

--Definition of a screen. (could be moved to another file, if necessary)
local function screen(screen_address, gpu_address)
 local gpu = setmetatable({
  screen_address = screen_address,
 },{
  __index = component.proxy(gpu_address)
 })
 gpu.bind(screen_address)
 return gpu
end

--generate screens
local t = {}
for name, address in pairs(data.screen) do
 t[name] = screen(address, data.gpu[name])
end
return t