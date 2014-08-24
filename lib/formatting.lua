local formatting = {}

local function groupNumbers(text)
 local main, last = string.match(text, "^(%d-)(%d?)$")
 local nreplaced
 main, nreplaced = string.gsub(main, "(%d%d%d)", "%1 ") 
 return main .. last, nreplaced
end

local signTable = setmetatable({
 ["+"] = "+",
 [" "] = " ",
 [""]  = "",
 [true] = "+",
},{
 __index = function(_,k)
  assert(k == nil, "Invalid 'positiveSign' format!")
  return ""
 end
})
local exponentialTable = setmetatable({
 [true] = "e",
 [false] = "f",
 [0] = "f",
 [1] = "e",
 [2] = "e",
 [3] = "e",
},{
 __index = function(_,k)
  assert(k == nil, "Invalid 'exponent' format!")
  return "g"
 end,
})

local function errorText(length)
 return string.rep("#", length or 1)
end

function formatting.number(number, format)
 local length = format.length
 
 if type(number) == "string" then
  --already a string, adjusting length...
  if length then
   if #number > length then
    return errorText(length)
   elseif #number < length then
    local space = string.rep(" ", length - #number)
    number = number .. space
   end
  end
  return number
 end
 if number == nil then
  return errorText(length or 1)
 end
 if type(number) ~= "number" then
  number = number()
 end
 
 local exponential = format.exponential
 local precision = format.precision
 local positiveSign = format.positiveSign
 local grouped = format.grouped
 local one = format.one
 local unit = format.unit or ""
 
 if number == nil then
  return errorText(length)
 end
 if one then
  number = number / one
 end
 if unit ~= "" then
  unit = " " .. unit
  length = length - #unit
 end
 
 
 local positiveSign = signTable[positiveSign]
 local formatPattern = "%" .. positiveSign
 if precision and precision > 0 then
  formatPattern = formatPattern .. "#"
 end
 if length then
  formatPattern = formatPattern .. length
 end
 if precision then
  formatPattern = formatPattern .. "." .. precision
 end
 formatPattern = formatPattern .. exponentialTable[exponential]
 local text = string.format(formatPattern,number)
 
 local firstPattern = "^(%s*)([%+%-]?)(%d*)(%.?)(.-)$"
 local secondPattern = "^(%d*)(%D*)(%d-)$" --the last part could be exponential
 
 local space, sign, first, separator, last = string.match(text, firstPattern)
 local decimals, base, exponent = string.match(last, secondPattern)
 
 local additionalSpaces
 local newSpaceLength = #space
 if format.grouped then
  --group numbers before the dot
  first = string.reverse(first)
  first, additionalSpaces = groupNumbers(first)
  first = string.reverse(first)
  newSpaceLength = newSpaceLength - additionalSpaces
  --group decimals
  decimals, additionalSpaces = groupNumbers(decimals)
  newSpaceLength = newSpaceLength - additionalSpaces
 end
 --adjust exponent
 if type(exponential) == "number" and exponent ~= "" then
  newSpaceLength = newSpaceLength - exponential + #exponent
  if #exponent > exponential then
   if string.byte(exponent, 1) ~= string.byte("0", 1) then
    --exponent is too large -> error
    return errorText(length)
   else
    exponent = string.sub(exponent, -exponential, -1)
   end
  elseif #exponent < exponential then
   --add preceding 0s
   exponent = string.rep("0", exponential - #exponent) .. exponent
  end
 end
 
 if length then
  --adjust length of spaces
  if newSpaceLength > 0 then
   space = string.rep(" ", newSpaceLength)
  elseif newSpaceLength == 0 then
   space = ""
  else
   return errorText(length)
  end
 end
 local result = {sign, space, first, separator, decimals, base, exponent}
 result = table.concat(result)
 if length and #result > length then
  return errorText(length)
 end
 --combine total number
 return result .. unit
end

function formatting.percentage(percentage, decimals, positiveSign)
 decimals = decimals or 0
 local length = 5
 if positiveSign or percentage<0 then
  length = length + 1
 end
 if decimals > 0 then
  length = length + decimals + 1
 end
 return formatting.unit(percentage,
 {
  exponential = false,
  precision = decimals,
  length = length,
  grouped = false,
  positiveSign = positiveSign,
  unit = "%",
 })
end

return formatting