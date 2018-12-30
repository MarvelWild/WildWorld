-- server main

local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

require("shared.libs")


ServerService=require("entity.service.server")
ConfigService=require("shared.entity.service.config")

love.load=function()
	local netState=Pow.net.state
	netState.isServer=true
	netState.isClient=false
	
	Entity.add(ServerService)
	ServerService.start()
end

love.update=function(dt)
	Pow.update(dt)
end


love.quit=function()
	Pow.quit()
end



