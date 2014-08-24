local misc = {}

function misc.getter(source)
 return assert(load("_ENV = ...;return "..source,nil,nil,{}))
end

return misc