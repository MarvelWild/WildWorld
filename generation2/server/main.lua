-- server main

local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

require("shared.libs")
Id=Pow.id

BaseEntity=require("shared.entity.base_entity")
Db=require("shared.lib.db.db")
ServerService=require("entity.service.server_service")
ConfigService=require("shared.entity.service.config")

Player=require("entity.player")

love.load=function()
	
	local netState=Pow.net.state
	netState.isServer=true
	netState.isClient=false
	
	Db.load()
	
	Entity.add(ServerService)
	ServerService.start()
end

love.update=function(dt)
	Pow.update(dt)
end


love.quit=function()
	Db.save()
	Pow.quit()
end



