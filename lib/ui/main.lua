
local gadgets = require 'ui.gadgets'
local ui = require 'ui'
local gfx = require 'gfx'
local os = require 'os'
local shell = require 'shell'
local interfaces = require 'config.interfaces'
local event = require 'event'
local fs = require 'filesystem'
local colors = require 'colors'
local uicolors = require 'ui.colors'
local misc = require 'misc'

local _,this_file = ...
local this_folder = fs.path(this_file)

local root
local function run()
 if root then
  local ok, err = pcall(root.drawAll)
  if not ok then
   io.stderr:write(err)
  end
 end
end
local function init()
 root = ui.root(gfx.new{
  x = 1,
  y = 1,
 })
 root.loadFile(fs.concat(this_folder, "../images/background.txt"), true)
 root.bind(interfaces.screens.monitoring.screen_address, interfaces.screens.monitoring)
 local env = misc.stdEnv(interfaces)
 env.uicolors = uicolors
 function env.color(fg, bg)
  return {foreground = fg, background = bg}
 end
 for name, gadget in pairs(gadgets) do
  env[name] = function(...)
   local g = gadget(...)
   if g then
    root.add(g)
   end
   return g
  end
 end
 --load ui from file "images/gadgets.lua"
 local loader = assert(loadfile(fs.concat(this_folder, "../images/gadgets.lua"), nil, env))
 loader()
end
local function stop()
 root = nil
end
event.timer(5,run,math.huge)
return {
 init = init,
 stop = stop,
}