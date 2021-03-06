
local gadgets = require 'ui.gadgets'
local os = require 'os'
local shell = require 'shell'
local interfaces = require 'interfaces.all'
local event = require 'event'
local files = require 'files'
local colors = require 'colors'
local uibase = require 'ui.base'
local uicolors = require 'ui.colors'
local misc = require 'misc'


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
 root = uibase({
  x = 1,
  y = 1,
 }, true)
 root.loadFile(files.resolve("images/background.txt"), true)
 root.bind(interfaces.screens.monitoring.screen_address, interfaces.screens.monitoring)
 local env = misc.stdEnv(interfaces)
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
 local loader = assert(loadfile(files.resolve("images/gadgets.lua"), nil, env))
 loader()
end
local function stop()
 root = nil
end
event.timer(5, run, math.huge)
return {
 init = init,
 stop = stop,
}