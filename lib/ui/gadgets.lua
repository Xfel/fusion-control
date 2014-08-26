local formatConfig = require 'ui.formatting'
local generalGadget = require 'ui.general'
local interfaces = require 'config.interfaces'
local uicolors = require 'ui.colors'
local uibase = require 'ui.base'
local colors = require 'colors'
local misc = require 'misc'

local function wrapGadget(format)
 return function(...)
  return generalGadget(format, ...)
 end
end

--primitive gadgets
local gadgets = {}
for k,format in pairs(formatConfig) do
 gadgets[k] = wrapGadget(format)
end
--complex gadgets
local function getTable(s)
 return string.gsub("(% or {})", "%%", s)
end
local function getName(s)
 return "("..s.." or {}).name"
end

local function fluid_type(s)
 return string.gsub("(%.tank.type)", "%%", s)
end
local function fluid_name(s)
 return getName(fluid_type(s))
end
local function fluid_amount(s)
 return string.gsub("%.tank.amount", "%%", s)
end
local function fluid_percentage(s)
 return string.gsub("(%.tank.amount / %.tank.capacity)", "%%", s)
end
local function production_type(s)
 s = getTable(s)
 return string.gsub("(%.result)", "%%", s)
end
local function production_name(s)
 return getName(production_type(s))
end
local function production_rate(s)
 return string.gsub("(% and (1 / %.ticks) or 0)", "%%", s)
end
local function me_amount(s)
 return s
end
local function eu_amount(s)
 return s
end


local function fixed_color(parent, color)
 parent.needsRedraw = true
 parent.foreground = {default = color.foreground}
 parent.background = {default = color.background}
 for _,child in ipairs(parent.list) do
  child.foreground = parent.foreground
  child.background = parent.background
 end
end
local function type_color(parent, color_table, type_path)
 local getter = misc.getter(type_path)
 function parent.color()
  local ftype = getter(interfaces) or "default"
  local color = color_table[ftype]
  for _,child in ipairs(parent.list) do
   --this is a bit dirty (it changes the childrens values from within a parents method)
   --But it saves a lot of redundant getter calls!
   child.color = color
  end
  return color
 end
end


function gadgets.tank(name, x, y)
 local root = uibase{
  x = x,
  y = y,
 }
 root.loadUIString("         ", 14, 3)
 
 local ftype = gadgets.fluid_type(fluid_name(name), 2, 1)
 local amount = gadgets.fluid(fluid_amount(name), 3, 2)
 local percentage = gadgets.percentage(fluid_percentage(name), 9, 3)
 
 type_color(root, uicolors.tank, fluid_type(name))
 root.add(ftype)
 root.add(amount)
 root.add(percentage)
 return root
end
function gadgets.tank_small(name, x, y, title)
 local root = uibase{
  x = x,
  y = y,
 }
 root.loadUIString("         ", 14, 3)
 
 local title = gadgets.text(title, 2, 1)
 local ftype = gadgets.fluid_type(fluid_name(name), 3, 2)
 local amount = gadgets.fluid_small(fluid_amount(name), 3, 3)
 local percentage = gadgets.percentage(fluid_percentage(name), 9, 3)
 
 type_color(root, uicolors.tank, fluid_type(name))
 
 root.add(title)
 root.add(ftype)
 root.add(amount)
 root.add(percentage)
 return root
end
function gadgets.production(name, x, y, title)
 local root = uibase{
  x = x,
  y = y,
 }
 root.loadUIString("         ", 12, 3)
 
 local title = gadgets.text(title, 2, 1)
 local ptype = gadgets.production_type(production_name(name), 3, 2)
 local prate = gadgets.production_rate(production_rate(name), 4, 3)
 
 type_color(root, uicolors.tank, production_type(name))
 
 root.add(title)
 root.add(ptype)
 root.add(prate)
 return root
end
function gadgets.me(name, x, y)
 local root = uibase{
  x = x,
  y = y,
 }
 
 local amount = gadgets.item(me_amount(name), 1, 1)
 
 root.add(amount)
 root.color = uicolors.tank.me
 amount.color = uicolors.tank.me
 return root
end
function gadgets.eu(name, x, y)
 local root = uibase{
  x = x,
  y = y,
 }
 
 local amount = gadgets.energy(eu_amount(name), 1, 1)
 
 root.add(amount)
 root.color = uicolors.tank.energy
 amount.color = uicolors.tank.energy
 return root
end
function gadgets.text(name, x, y)
 local obj = uibase{
  x = x,
  y = y,
 }
 obj.loadString(name)
 obj.color = uicolors.default
 return obj
end
function gadgets.file(name, x, y)
 local obj = uibase{
  x = x,
  y = y,
 }
 obj.loadFile(name)
 obj.color = uicolors.default
 return obj
end

--TODO: variable text
return gadgets