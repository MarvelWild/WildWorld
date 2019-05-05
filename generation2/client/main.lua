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
Gamera=require("shared.lib.gamera.gamera")
Cam = Gamera.new(0,0,128,128)


local doDraw=function()
	Pow.draw()
end


love.draw=function()
	Cam:draw(doDraw)
end

love.load=function()
	local netState=Pow.net.state
	netState.isServer=false
	netState.isClient=true
	
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	
	Entity.add(GameService)
	Entity.add(ClientService)
	GameService.start()
	Cam:setScale(4)
	-- todo
	Cam:setWorld(0,0,4096,4096)
end

love.update=function()
	local player=GameState.getPlayer()
	if player~=nil then
		Cam:setPosition(player.x, player.y)	
		log("cam set pos:"..player.x..','..player.y)
		log("cam pos:"..Cam:getPosition())
	end
	Pow.update()
end

love.mousepressed=function(x,y,button,istouch)
	local gameX,gameY
	gameX,gameY=Cam:toWorld(x,y)
	
	GameService.mousepressed(gameX,gameY,button,istouch)
end

love.resize=function(width, height)
	Cam:setWindow(0,0,width,height)
end


love.quit=function()
	Pow.quit()
end