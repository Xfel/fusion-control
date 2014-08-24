--[[
 object format:
  obj={
   width = 7,
   height = 2,    --the same as lines.n
   lines = {      --contains the text
    n = 2,
    [1] = {
     n = 3,
     [1] = "  ",  --2 spaces
     [2] = "abc", --normal text
     [3] = "  ",
    },
    [2] = {
     n = 5,
     [1] = "a",
     [2] = " ",
     [3] = "=",
     [4] = " ",
     [5] = "123",
    },
   },
   spaces = {     --contains all space tokens to identify them during drawing
                  --max memory footprint: O(n) with n as the amount of space characters in the file
     [" "] = true,
     ["  "] = true,
   },
   foreground = {
    n = 2,
    [1] = {
     n = 1,
     [1] = {
      color = 0xFFFFFF,
      length = 7,
     },
    },
    [2] = {
     n = 3,
     [1] = [
      
     }
    },
    
   
   },
  }


 --TODO: change pipelines to use closure returns for initialization
 
  function(globalData) --pipeline initialiser
   return function(output, tokenData) --pipeline step
    if ... then
     --abort this token
     return
    end
    output(tokenData) --output 1st token
    output(tokenData) --output 2nd token
    return abortLine, abortAll
   end
  end
 
  data: a table filled with data to certain keys
 
 
]]

local misc = require 'misc'
local colors = require 'colors'

local gfx={}



local function run_pipeline(pipeline, listSending)
 --how to get a good speed: reuse the sending table as the receiving table for the next step
 --local listSending = table.pack(...)
 local listReceiving = {n = 0}
 
 --each pipeline step uses this function to output its data
 --the function is given as a parameter
 local function output(data)
  local n = listReceiving.n + 1
  listReceiving[n] = data
  listReceiving.n = n
 end
 
 local returned = false -->abortAll
 
 for _,func in ipairs(pipeline) do
  for index = 1, listSending.n do
   data = listSending[index]
   local abortLine, abortAll = func(output, data)
   if abortLine then
    --end the line here, go to next step
    break
   end
   if abortAll then
    --the functions can return true to abort execution
    --(e.g. at the end of, above or below a clipping region)
    returned = true
    break
   end
  end
  listSending, listReceiving = listReceiving, listSending
  listReceiving.n = 0
 end
 return returned
end
local function init_pipeline(initializers, ...)
 local pipeline = {}
 --create step closures
 for index = 1, #initializers do
  pipeline[index] = initializers[index](...)
 end
 --return a 'launching' closure
 return function(...)
  return run_pipeline(pipeline, ...)
 end
end

local function initToken(x, y, text, isSpace)
 return {
  x = x,
  y = y,
  text = text,
  isSpace = isSpace,
  skip = 0,
  length = #text,
  foreground = nil,
  background = nil,
 }
end
local function splitToken(data, firstLength)
 --copy data
 local data2 = {}
 for k,v in pairs(data) do
  data2[k] = v
 end
 --adjust first part
 data.length = firstLength
 --adjust second part
 data2.x = data2.x + firstLength
 data2.skip = data2.skip + firstLength
 data2.length = data2.length - firstLength
 return data, data2
end
local function makeLine(parts, index, length)
 if length <= 0 then
  return ""
 end
 local buffer = {parts[index + 1]}
 buffer[length] = parts[index + 3]
 local middle = parts[index + 2]
 for i = 2, length - 1 do
  buffer[i] = middle
 end
 return {n = 1, table.concat(buffer, "", 1, length)}
end

local function makeColor(value)
 if value == nil then
  return nil
 end
 if type(value) == "number" then
  return value
 end
 if type(value) == "string" then
  return colors[value]
 end
 return value()
end




function gfx.new(obj)
 obj = obj or {}
 function obj.loadIterator(jointLines, ...)
  --definitions of loop variables and functions
  local lines = {n = 0}
  local spaces = {}
  local maxWidth = 0
  local tokens
  local width   --to determine width of the text / image
  local function addLine()
   --prepare new token list, reset line width, add line in list
   tokens = {n = 0}
   width = 0
   lines.n = lines.n + 1
   lines[lines.n] = tokens
  end
  local function addToken(token, isSpace)
   --add new token to list, add token to list of known space tokens if applicable, update maximum width
   tokens.n = tokens.n + 1
   tokens[tokens.n] = token
   if isSpace then
    spaces[token] = true
   end
   width = width + #token
   maxWidth = math.max(width, maxWidth)
  end
  --go through all lines
  for line in ... do
   line = string.gsub(line,"\r?\n?","")
   addLine()
   if jointLines then
    addToken(line)
   else
    for space, word in string.gmatch(line,"(%s*)(%S*)") do
     if space~="" then
      addToken(space, true)
     end
     if word~="" then
      addToken(word)
     end
    end
   end
   --Normally there wouldn't be such a thing as an empty token.
   --Therefore it qualifies as an 'end of line' token.
   --It can be extended to make the line longer. The drawing code takes special care for this one.
   addToken("", true)
  end
  obj.lines = lines
  obj.spaces = spaces
  obj.width = maxWidth
  obj.height = lines.n
  
  return obj
 end
 function obj.loadFile(file, jointLines)
  local file, reason = io.open(file)
  if not file then
   error(reason, 2)
  end
  local result = obj.loadIterator(jointLines, file:lines("*l"))
  file:close()
  return result
 end
 function obj.loadString(text, jointLines)
  return obj.loadIterator(jointLines, string.gmatch(text, "([^\r\n]*)\r?\n?"))
 end
 
 function obj.loadUIString(template, width, height)
  local parts = table.pack(string.match(template, "(.)(.)(.)\r?\n?(.)(.)(.)\r?\n?(.)(.)(.)"))
  assert(parts[1] ~= nil, "Invalid UI template: at least 9 characters necessary!")
  local lines = {n = height}
  if height > 0 then
   local top = makeLine(parts, 0, width)
   local middle = makeLine(parts, 3, width)
   local bottom = makeLine(parts, 6, width)
   lines[1] = top
   lines[height] = bottom
   for i = 2, height - 1 do
    lines[i] = middle
   end
  end
  obj.width = width
  obj.height = height
  obj.lines = lines
  obj.spaces = {}
 end
 ----editing----
 function obj.replace(pattern, replacementFunction)
  pattern = string.gsub(pattern, "^(%^?)", "%1)()")
  pattern = string.gsub(pattern, "(%$?)$", "()(%1")
  for _,line in ipairs(obj.lines) do
   local index = 1
   local function add(token)
    table.insert(line, index, token)
    index = index + 1
   end
   local function remove()
    table.remove(line, index)
    index = index - 1
   end
   while true do
    local token = line[index]
    if token == nil then
     break
    end
    if type(token) == "string" then
     local from = 1
     for begin, match, afterEnding in string.gmatch(token, pattern) do
      if match ~= "" then
       local replacements = table.pack(replacementFunction(match, afterEnding - begin))
       if replacements.n > 0 then
        --1st: not replaced
        if from < begin then
         add(string.sub(token, from, begin - 1))
        end
        --2nd: replaced
        for _,replacement in ipairs(replacements) do
         add(replacement)
        end
        from = afterEnding
       end
      end
     end
     if from >= #token then
      remove()
     elseif from > 1 then
      line[index] = string.sub(token, from, #token)
     end
    end
    index = index + 1
   end
  end
 end
 ----drawing----
 function obj.iteratePipelined(originX, originY, onLine)
  local spaces = obj.spaces or {}
  local y = originY
  for _,line in ipairs(obj.lines) do
   --start a new line
   local x = originX
   local lineData = {}
   local n = 0
   for _,token in ipairs(line) do
    local text = tostring(token)
    n = n + 1
    --summarize all known information in one table
    lineData[n] = initToken(x, y, text, spaces[text])
    x = x + #text
   end --for _,token in ipairs(line) do
   lineData.n = n
   --execute action
   if onLine(lineData) then
    --reached the end of the clipping region
    return
   end
   y = y + 1
  end --for _,line in ipairs(obj.lines) do
 end
 function obj.debug(gpu, x, y, pipeline, customData)
  --copy and modify pipeline (-> use print as last function)
  local newPipeline = {}
  local n = #pipeline
  for index = 1, n - 1 do
   newPipeline[index] = pipeline[index]
  end
  newPipeline[n] = print
  obj.draw(gpu, x, y, newPipeline, customData)
 end
 function obj.draw(gpu, x, y, pipeline, customData)
  if pipeline == nil then
   pipeline = obj.pipeline or gfx.pipeline_default
  end
  local doPipeline = init_pipeline(pipeline, setmetatable({
   gpu = gpu,
   obj = obj,
   x = x,
   y = y,
  },{
   __index = customData, --if the user supplies custom data
  }))
  obj.iteratePipelined(x, y, doPipeline)
 end
 --TODO: a function which 'bakes' the whole process into a final data-list or function
 --> prepares everything for faster execution, while retaining some flexibility for reusability (e.g. position)
 return obj
end

function gfx.clipping_rect(x, y, width, height)
 local rect = {x=x, y=y, n=height}
 local line = {n=1,{length = width, visible = true}}
 for i = 1, height do
  rect[i] = line
 end
 return rect
end

--[[
 gfx.pipeline_map: returns a pipeline initializer
 data[source_name][line][index][source_field]: source of property data
 
 token[target_field]: destination of property data, if 'action' is a simple assigning function
 action(token_data, target_name, property_value, nil_reason): abortToken, abortLine, abortAll
       token_data will not be processed if 'action' returns true
]]
function gfx.pipeline_map(origin_name, source_name, source_field, action)
 --let source_name reference to global_data
 --ATTENTION: the codes are not checked for security, but that way you can specify multiple locations via "a or b"
 local origin_getter = misc.getter(origin_name)
 local map_getter = misc.getter(source_name)
 local property_getter = misc.getter(source_field)
 
 return function(data)
  --currently visited property map part
  local currentX, currentY
  local currentLength, currentIndex
  local currentLine, currentProperty
  
  local originX, originY = origin_getter(data)
  local property_map = map_getter(data)
  if property_map == nil then
   return function(output, data) output(data) end
  end
  
  
  local function mapper(output, data)
   --[[
    basic function:
     1st determine property token for this token
     2nd set corresponding property
     3rd split text token if necessary (if multiple property tokens apply)
   ]]
   local x, y = data.x, data.y
   local length = data.length
   if currentY ~= y then
    --begin new line
    currentX = originX - 1
    currentY = y
    currentLength = 1
    currentIndex = 0
    local lineNr = y - originY + 1
    currentLine = property_map[lineNr]
    currentProperty = nil
   end
   if currentLine ~= nil then
    --determine property token overlapping the first part of the data token
    while x >= currentX + currentLength do
     currentIndex = currentIndex + 1
     currentProperty = currentLine[currentIndex]
     if currentProperty == nil then
      --end of line
      break
     end
     currentX = currentX + currentLength
     currentLength = currentProperty.length
    end
   else
    currentProperty = nil
   end
   
   --get value, split data token if necessary
   local data2
   if currentLine then
    if x < currentX and x + length > currentX then
     --that might happen if a property map is used with an origin differing from the drawing position
     data, data2 = splitToken(data, currentX - x)
     assert(currentProperty == nil)
    end
   end
   if currentProperty and data2 == nil then
    if x + length > currentX + currentLength then
     --split data token
     data, data2 = splitToken(data, currentX - x + currentLength)
    end
   end
   local property_value, nil_reason
   if currentProperty then
    property_value = property_getter(currentProperty)
    nil_reason = "no value"
   elseif currentLine then
    if currentIndex == 0 then
     nil_reason = "left of data"
    else
     nil_reason = "right of data"
    end
   elseif y < originY then
    nil_reason = "above data"
   else
    nil_reason = "below data"
   end
   --execute action, get returns
   local abortData, abortLine, abortAll = action(data, property_value, nil_reason)
   if abortLine or abortAll then
    return abortLine, abortAll
   end
   if not abortData then
    output(data)
   end
   if data2 then
    --2 reasons for tail recursion: 1st: it does not fill the stack, 2nd: results are propagated to the calling function
    return mapper(output, data2)
   end
  end
  return mapper
 end
end
local function pipeline_set(k)
 return function(t,v)
  t[k] = v
 end
end
gfx.pipeline_foreground = gfx.pipeline_map("x, y", "foreground or obj.foreground", "color", pipeline_set("foreground"))
gfx.pipeline_background = gfx.pipeline_map("x, y", "background or obj.background", "color", pipeline_set("background"))
gfx.pipeline_clipping = gfx.pipeline_map("(clipping or {}).x or x,(clipping or {}).y or y", "clipping or obj.clipping", "visible", function(_, visible, nil_reason)
 return not visible, nil_reason == "right of data", nil_reason == "below data"
end)

function gfx.pipeline_draw(data)
 local gpu = data.gpu
 local obj = data.obj
 --get default color
 local foreground_std = makeColor((obj.foreground or {}).default) or gpu.getForeground()
 local background_std = makeColor((obj.background or {}).default) or gpu.getBackground()
 return function(output, data)
  --get and set colors
  local background = makeColor(data.background) or background_std
  local foreground = makeColor(data.foreground) or foreground_std
  if gpu.getBackground() ~= background then
   --speed optimization: only call this function when necessary
   gpu.setBackground(background)
  end
  -- get drawn string
  local text = data.text
  if text ~= "" then
   if gpu.getForeground() ~= foreground then
    --speed optimization: only call this function when necessary
    gpu.setForeground(foreground)
   end
   
   text = string.sub(text, data.skip + 1, data.skip + data.length)
   -- drawing
   gpu.set(data.x, data.y, text)
  elseif text and data.length > 0 then
   gpu.fill(data.x, data.y, data.length, 1, " ")
  end
 end
end
function gfx.pipeline_skip_space(data)
 return function(output, data)
  if not data.isSpace then
   output(data)
  end
 end
end
function gfx.pipeline_expand_lines(data)
 local obj = data.obj
 return function(output, data)
  if data.text == "" then
   data.length = obj.width - data.x
  end
  output(data)
 end
end


gfx.pipeline_default = {
 gfx.pipeline_clipping,
 gfx.pipeline_foreground,
 gfx.pipeline_background,
 gfx.pipeline_draw,
}

return gfx