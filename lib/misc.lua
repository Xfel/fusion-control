local colors = require 'colors'

local misc = {}

function misc.getter(source)
 return assert(load("local _ENV = ...;return "..source,nil,nil,{}))
end
function misc.stdEnv(env)
 return setmetatable({
  math = math,
  string = string,
  pairs = pairs,
  ipairs = ipairs,
  tostring = tostring,
  tonumber = tonumber,
  colors = colors,
  pcall = pcall,
  print = print,
 },{
  __index = env
 })
end

return misc