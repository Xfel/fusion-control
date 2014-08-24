local ui = require 'ui'
local gfx = require 'gfx'
local interfaces = require 'config.interfaces'
local formatting = require 'formatting'
local misc = require 'misc'

return function(formatTable, name, x, y)
 local getter = misc.getter(name)
 
 local object
 object = ui.new(gfx.new{
  x = x,
  y = y,
  width = formatTable.length,
  height = 1,
  pipeline = {
   --simplified pipeline
   gfx.pipeline_draw,
  },
  lines = {
   {},
  },
  onUpdate = function()
   local text = formatting.number(getter(interfaces), formatTable)
   local lines = object.lines
   if text ~= lines[1][1] then
    object.needsRedraw = true
    lines[1][1] = text
   end
  end,
  color = function(fg, bg)
   if fg then
    object.foreground = {default = fg}
   end
   if bg then
    object.background = {default = bg}
   end
   return object
  end,
 })
 return object
end