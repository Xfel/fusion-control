--load library
--collect parameters
local main = require("ui.main")
local args = {...}

--get parameter
local action = args[1] or "init"
local actionList = main

--define some aliases
local aliases = {
 start = "init",
 reload = "init",
 ["exit"] = "stop",
}
action = aliases[action] or action

local selectedAction = actionList[action]
assert(selectedAction,"Unknown parameter \""..action.."\"")
selectedAction()