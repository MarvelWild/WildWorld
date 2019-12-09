-- client main
local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

-- todo: on server too

-- todo: mobdebug failed, try newer one
-- require "shared/lib/strict"

-- defined in pow
TSerial=nil

-- for grease
_G.common=nil

-- for mobdebug
-- ...=nil


require("shared.libs")
Pow.setup(
	{
		--"server",
		"client"
	}
)

Event=Pow.net.event
ConfigService=require("shared.entity.service.config")
ClientService=require("entity.service.client_service")
EditorService=require("entity.service.editor_service")
GameService=require("entity.service.game")
CollisionService=require("entity.service.collision_service")
GameState=require("entity.service.game_state")


love.draw=function()
	Pow.draw()
end

local initUi=function()
	local hotbar=require("entity.ui.hotbar")
	Entity.add(hotbar)
end


local loadEntity=function(path)
	local entity=require(path)
	local globalVarName=Pow.allen.capitalizeFirst(entity.entityName)
	Pow.registerGlobal(globalVarName, entity)
	Entity.addCode(entity.entityName,entity)
end


local loadEntities=function()
	Movable=require "shared.entity.trait.movable"
	-- code
	Entity.addCode("player",require("entity.world.player"))
	
	loadEntity("entity.world.seed")
	loadEntity("entity.world.tree")
	loadEntity("entity.world.panther")
	loadEntity("entity.world.generic")
end


love.load=function()
	local netState=Pow.net.state
	netState.isServer=false
	netState.isClient=true
	
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	
	loadEntities()
	Entity.add(GameService)
	Entity.add(ClientService)
	Entity.add(EditorService)
	Entity.add(CollisionService)
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
	Pow.mousePressed(x,y,button,istouch)
end

love.resize=function(width, height)
	Pow.resize(width, height)
end

love.keypressed=function(key, scancode, isrepeat)
	Entity.keyPressed(key)
end


local doQuit=function()
	Pow.quit()
	
	log("*** Quit ***")
	love.event.quit()
end

local startQuitTimer=function()
	log("startQuitTimer")
	
	log("quitting by timer")
	Pow.timer:after(2, doQuit)
end

-- are we in logoff process
local _isLogoff=false


local logoff=function()
	log("logoff")
	_isLogoff=true

	startQuitTimer()
	
	local event=Event.new()
	event.code="logoff"
	event.target="server" 
	Event.process(event,doQuit)
	
	-- response: removed player entity
end



love.quit=function()
	if not _isLogoff then
		logoff()
		
		-- Abort quitting. If true, do not close the game.
		return true
	end
	
	-- ok if we hit quit twice, then don't wait for logoff
	doQuit()
	
	-- proceed with quit
	return false
end