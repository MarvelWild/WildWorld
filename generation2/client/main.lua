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

local initUi=function()
	local hotbar=require("entity.ui.hotbar")
	Entity.add(hotbar)
end


love.load=function()
	local netState=Pow.net.state
	netState.isServer=false
	netState.isClient=true
	
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	
	Entity.add(GameService)
	Entity.add(ClientService)
	GameService.start()
	
	Pow.load()
	
	initUi()
end

love.update=function(dt)
	Pow.update(dt)
	local player=GameState.getPlayer()
	if player~=nil then
		Pow.cam:setPosition(player.x, player.y)	
	end
end

love.mousepressed=function(x,y,button,istouch)
	local gameX,gameY
	gameX,gameY=Pow.getWorldCoords(x,y)
	
	GameService.mousepressed(gameX,gameY,button,istouch)
end

love.resize=function(width, height)
	Pow.resize(width, height)
end


love.quit=function()
	Pow.quit()
end