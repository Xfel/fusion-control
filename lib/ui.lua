local ui = {}

function ui.new(obj)
 obj = obj or {}
 ----parenting and structure----
 obj.list = obj.list or {n = 0}
 function obj.add(child)
  if child.parent then
   child.remove()
  end
  local list = obj.list
  local n = #list + 1
  list[n] = child
  child.parent = obj
 end
 function obj.remove(index)
  if type(index) == "number" then
   --index is the position in the child table
   local list = obj.list
   table.remove(list, index)
  elseif index ~= nil then
   --index is the object that should be removed
   local list = obj.list
   for i, child in ipairs(list) do
    if child == index then
     --found it, remove object at index, avoiding duplicated code...
     return obj.remove(i)
    end
   end
  else
   --this object should be removed from its parent
   local parent = obj.parent
   if parent then
    obj.parent = nil
    return parent.remove(obj)
   end
  end
 end
 ----callers and wrappers----
 local function makeFunc(func)
  --if 'func' is the name of a function it returns a wrapper to call the function for the corresponding object
  if type(func) == "string" then
   return function(obj, ...)
    local f = obj[func]
    if f then
     return f(...)
    end
    --else: ignore that, there might be static, invisible objects for whatever reason...
   end
  end
  return func
 end
 function obj.iterate(action, reversed, ...)
  --make sure 'action' is a function
  action = makeFunc(action)
  --prepare loop
  local list = obj.list
  local index, step
  if reversed then
   index = #list
   step = -1
  else
   index = 1
   step = 1
  end
  --run loop
  while true do
   local obj = list[index]
   if obj == nil then
    break
   end
   --execute action
   local returned = action(obj, ...)
   if returned ~= nil then
    return returned
   end
   index = index + step
  end
 end
 function obj.recursion(action, reversed, ...)
  action = makeFunc(action)
  local recursionFunc
  if reversed then
   recursionFunc = function(obj, ...)
    --reversed order: first iterate on children, then do something
    local returned = obj.iterate(recursionFunc, true, ...)
    if returned then
     return returned
    end
    return action(obj, ...)
   end
  else
   recursionFunc = function(obj, ...)
    --normal order: first do something, then repeat on children
    local returned = action(obj, ...)
    if returned then
     return returned
    end
    return obj.iterate(recursionFunc, false, ...)
   end
  end
  return recursionFunc(obj, ...)
 end
 function obj.wrapRecursion(action, reversed)
  --obj.recursion("onClick", true, x, y) -> obj.onClickAll(x, y)
  return function(...)
   obj.recursion(action, reversed, ...)
  end
 end
 ----event functions----
 function obj.onDraw(gpu)
  --determine drawing coordinates
  local x, y = obj.x or 1, obj.y or 1
  local parent = obj.parent
  if parent then
   local px, py = parent.absX or 1, parent.absY or 1
   obj.absX = px + x - 1
   obj.absY = py + y - 1
  else
   obj.absX = x
   obj.absY = y
  end
  --check if redrawing is necessary
  if obj.onUpdate then
   obj.onUpdate()
  end
  if parent then
   --order of operation is important to use the needsRedraw == nil initialization
   obj.needsRedraw = parent.drawn or obj.needsRedraw
  end
  
  if obj.needsRedraw ~= false then
   if obj.draw then
    --drawing
    obj.draw(gpu, obj.absX, obj.absY)
   end
   --even if there was no drawing operation: forward the drawing instruction to the child elements
   obj.needsRedraw = false
   obj.drawn = true
  else
   obj.drawn = false
  end
 end
 
 return obj
end

function ui.root(obj)
 obj = ui.new(obj)
 
 ----event processing----
 function obj.bind(screen, gpu)
  if obj.screen ~= nil then
   obj.unbind()
  end
  obj.gpu = gpu
  obj.screen = screen
  --TODO: register event
 end
 function obj.unbind()
  obj.gpu = nil
  obj.screen = nil
  --TODO: unregister events
 end
 function obj.onEvent(name, ...)
  --TODO: work on event table
 end
 local drawAll = obj.wrapRecursion("onDraw", false)
 obj.drawAll = function()
  drawAll(obj.gpu)
 end
 
 return obj
end

ui.new()

return ui