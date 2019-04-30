-- client game state
-- global GameState

local _={}

_.level=nil

-- заполняется в client_service onStateReceived
_.lastState=nil


return _