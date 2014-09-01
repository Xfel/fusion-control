local function newRate(t)
 return setmetatable(t or {},{
  __add = function(a, b)
   local new = newRate()
   for k,v in pairs(a) do
    new[k] = v
   end
   for k,v in pairs(b) do
    local cur = new[k] or 0
    new[k] = cur + v
   end
   return new
  end,
  __sub = function()
   local new = newRate()
   for k,v in pairs(a) do
    new[k] = v
   end
   for k,v in pairs(b) do
    local cur = new[k] or 0
    new[k] = cur + v
   end
   return new
  end,
 })
end

return newRate