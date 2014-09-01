--[[
 file: all.lua
 description:
   This file loads all interface modules and returns a table containing all of them.
]]

--list of all modules, name = true to load the module 'name'
local modules = {
 --controlling and monitoring
 reactor = true,
 generators = true,
 machines = true,
 tanks = true,
 me = true,
 --database
 items = "data.items",
 recipes = "data.recipes",
 uicolors = "ui.colors",
 --summary and statistics (refers to the previous modules)
 balance = true,
 availability = true,
}

local interfaces = require 'interfaces'

--loading...
for name, path in pairs(modules) do
 if path then
  if type(path) ~= "string" then
   path = "interfaces." .. name
  end
  interfaces[name] = require(path)
 end
end

return interfaces