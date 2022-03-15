-- client main
local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

-- globals
_traceback=debug.traceback
Pow=require("lib.pow2.pow")

Entity_service=require("service.entity_service")

love.load=function()
end


love.draw=function()
end

love.update=function(dt)
	Entity_service.update()
end
