--TODO: load libraries and settings
--depending on arguments:
--start display timer
--stop display timer
local gadgets = require 'ui.gadgets'
local ui = require 'ui'
local gfx = require 'gfx'



local root
local function init()
 root = ui.root(gfx.new{
  x = 1,
  y = 1,
 })
 root.loadFile(shell.resolve("images/background.txt"), true)
 root.bind(interfaces.screens.monitoring)
 
 local env = {}
 for name,gadget in pairs(gadgets) do
  env[name] = function(...)
   local g = gadget(...)
   root.add(g)
  end
 end
 --load ui from file "images/gadgets.lua"
 local loader = assert(loadfile(shell.resolve("images/gadgets.lua") ,nil ,env))
 loader()
end
local function run()
 for i = 1, 10 do
  root.drawAll()
 end
end

init()
run()