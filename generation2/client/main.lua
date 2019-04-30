-- client main

local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

require("shared.libs")
Pow.setup(
	{
		--"server",
		"client"
	}
)

ConfigService=require("shared.entity.service.config")
ClientService=require("entity.service.client_service")
GameService=require("entity.service.game")
GameState=require("entity.service.game_state")

love.draw=function()
	Pow.draw()
end

love.load=function()
	local netState=Pow.net.state
	netState.isServer=false
	netState.isClient=true
	
	Entity.add(GameService)
	Entity.add(ClientService)
	GameService.start()
end

love.update=function()
	Pow.update()
end


love.quit=function()
	Pow.quit()
end