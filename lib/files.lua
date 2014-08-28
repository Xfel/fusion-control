local shell = require 'shell'
local files = {}

function files.resolve(name)
 return shell.resolve(name, "")
end
function files.open(name, ...)
 local name = files.resolve(name)
 return io.open(name, ...)
end
function files.readAll(name)
 local stream = assert(files.open(name))
 local text = stream.read("*a")
 stream.close()
 return text
end

return files