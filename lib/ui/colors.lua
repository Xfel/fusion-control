local items = require 'data.items'

local function c(fg,bg)
 return {
  foreground = fg,
  background = bg,
 }
end

local colors = {
 pipe = {
  [items.cells]      = c(0xAAAAAA,0x000000),
  [items.hydrogen]   = c(0x0000FF,0x000000),
  [items.deuterium]  = c(0xAAAA00,0x000000),
  [items.tritium]    = c(0xFF0000,0x000000),
  [items.helium3]    = c(0xAAAA44,0x000000),
  [items.plasma]     = c(0xFFFF88,0x000000),
  [items.wolframium] = c(0x888888,0x000000),
  [items.berylium]   = c(0x00AA00,0x000000),
  [items.lithium]    = c(0xAAAAAA,0x000000),
  [items.iridium]    = c(0xFFFFFF,0x000000),
  [items.platinum]   = c(0xAAAA88,0x000000),
  energy             = c(0xFFFF00,0x000000),
  default            = c(0x444444,0x000000),
 },
 tank = {
  [items.cells]      = c(0x444444,0xAAAAAA),
  [items.hydrogen]   = c(0x444444,0x0000FF),
  [items.deuterium]  = c(0x444444,0xAAAA00),
  [items.tritium]    = c(0x444444,0xFF0000),
  [items.helium3]    = c(0x444444,0xFFFF88),
  [items.plasma]     = c(0x444444,0xFFFF88),
  [items.wolframium] = c(0x444444,0x888888),
  [items.berylium]   = c(0x444444,0x00AA00),
  [items.lithium]    = c(0x444444,0xAAAAAA),
  [items.iridium]    = c(0x444444,0xFFFFFF),
  [items.platinum]   = c(0x444444,0xAAAA88),
  energy             = c(0xFFFF00,0x000000),
  me                 = c(0xFFFFFF,0x000000),
  default            = c(0xFFFFFF,0x000000),
 },
 balance = {
  positive           = c(0x00FF00,0x000000),
  negative           = c(0xFF0000,0x000000),
  default            = c(0xFFFFFF,0x000000),
 },
 enabled             = c(0x44FF44,0x000000),
 disabled            = c(0xFF2222,0x000000),
 temporary           = c(0xFFFF44,0x000000),
 default             = c(0xFFFFFF,0x000000),
}

return colors