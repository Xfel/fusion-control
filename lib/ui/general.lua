local ui = require 'ui'
local gfx = require 'gfx'
local interfaces = require 'config.interfaces'
local formatting = require 'formatting'
local misc = require 'misc'
local uibase = require 'ui.base'

return function(formatTable, name, x, y)
 local value
 if type(name) == "function" then
  value = name
 elseif type(name) == "string" then
  local getter = misc.getter(name)
  local env = misc.stdEnv(interfaces)
  value = function()
   return getter(env)
  end
 else
  error("Invalid property name!", 2)
 end
 
 local object = uibase{
  x = x,
  y = y,
  width = formatTable.length,
  height = 1,
  color = formatTable.color,
  text = function()
   return formatting.number(value(), formatTable)
  end,
 }
 return object
end