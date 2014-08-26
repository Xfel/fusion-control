local ui = require 'ui'
local gfx = require 'gfx'
local interfaces = require 'config.interfaces'
local formatting = require 'formatting'
local misc = require 'misc'
local uibase = require 'ui.base'

return function(formatTable, name, x, y)
 local getter = misc.getter(name)
 
 local object = uibase{
  x = x,
  y = y,
  width = formatTable.length,
  height = 1,
  text = setmetatable({},
  {
   __tostring = function()
    return formatting.number(getter(interfaces), formatTable)
   end
  }),
 })
 return object
end