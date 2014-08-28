--[[
 the basic reactor gadget
 extending ui + gfx by supporting dynamic texts and dynamic colors
 
]]
local gfx = require 'gfx'
local ui = require 'ui'
local uicolors = require 'ui.colors'


local base = function(obj, isRoot, ignoreSpace)
 obj = gfx.new(obj)
 if isRoot then
  obj = ui.root(obj)
 else
  obj = ui.new(obj)
 end
 obj.pipeline = {
  --simplified pipeline
  gfx.pipeline_draw,
 }
 obj.color = obj.color or uicolors.default
 
 
 function obj.onUpdate()
  obj.updateText()
  obj.updateColor()
 end
 local oldText = nil
 function obj.updateText()
  local text = obj.text
  if text == nil then
   return
  end
  if type(text) == "function" then
   text = text()
  end
  if text == oldText or text == nil then
   return
  end
  oldText = text
  obj.loadString(text, not ignoreSpace)
  obj.needsRedraw = true
 end
 local oldColor
 function obj.updateColor()
  local color = obj.color
  if color == nil then
   return
  end
  if type(color) == "function" then
   color = color()
  end
  if color == oldColor or color == nil then
   return
  end
  oldColor = color
  obj.foreground = obj.foreground or {}
  obj.background = obj.background or {}
  obj.foreground.default = color.foreground
  obj.background.default = color.background
  obj.needsRedraw = true
 end
 return obj
end

return base