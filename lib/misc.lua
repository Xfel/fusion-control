local colors = require 'colors'
local files = require 'files'
local fs = require 'filesystem'
local shell = require 'shell'
local misc = {}

--that makes loading files from within the library directory easier
--(use files.open with a relative path)
local _, this_file = ...
local lib_dir = fs.path(this_file)
shell.setPath(lib_dir .. ":" .. shell.getPath())

function misc.getter(source)
 return assert(load("local _ENV = ...;return "..source,nil,nil,{}))
end
function misc.stdEnv(env, dir)
 dir = dir or "./"
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
  import = files.readAll,
 },{
  __index = env
 })
end

return misc