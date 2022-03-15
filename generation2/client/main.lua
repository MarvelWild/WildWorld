-- client main
local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

_traceback=debug.traceback

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

Hacks={}
Hacks.suppress_known_warns=true

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
Pin_service=Pow.multirequire(
	"shared.entity.service.pin_service",
	"entity.service.pin_service"
)


DebuggerService=require("shared.entity.service.debugger_service")
GameService=require("entity.service.game")
CollisionService=require("entity.service.collision_service")
VfxService=require("entity.service.vfx_service")
MusicService=require("entity.service.music_service")
GameState=require("entity.service.game_state")

Animation_service=Pow.multirequire("shared.entity.service.animation_service","entity.service.animation_service")

CraftList=require("entity.ui.craft_list")

_deref=GameState.findEntity


love.draw=function()
	Pow.draw()
	DebuggerService.do_draw()
end

local initUi=function()
	local hotbar=require("entity.ui.hotbar")
	Entity.add(hotbar)
	
	local splash=require("entity.ui.splash")
	Entity.add(splash)
end


local loadEntity=function(path)
	local entity=require(path)
	local globalVarName=Pow.allen.capitalizeFirst(entity.entity_name)
	Pow.registerGlobal(globalVarName, entity)
	Entity.addCode(entity.entity_name,entity)
end


local loadEntities=function()
	Movable=require "shared.entity.trait.movable"
	-- Mountable=Pow.multirequire("shared.entity.trait.mountable","entity.trait.mountable")
	
	-- no client part for now
	Mountable=require("shared.entity.trait.mountable")
	
	-- code
	Entity.addCode("player",require("entity.world.player"))
	
	
	WorldEntities=Pow.loadEntitiesFromDir("entity/world")
--	loadEntity("entity.world.seed")
--	loadEntity("entity.world.tree")
--	loadEntity("entity.world.panther")
--	loadEntity("entity.world.generic")
--	loadEntity("entity.world.humanoid")
end


love.load=function()
	local full_log_arg=Pow.arg.get("full_log=", "0")
	if full_log_arg=="1" then
		Debug.set_full_log()
	end
	
	
	local netState=Pow.net.state
	netState.isServer=false
	netState.isClient=true
	
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	
	loadEntities()
	Entity.add(GameService)
	Entity.add(ClientService)
	Entity.add(EditorService)
	Entity.add(DebuggerService)
	Entity.add(CollisionService)
	Entity.add(Animation_service)
	Entity.add(Pin_service)
	Entity.add(VfxService)
	Entity.add(MusicService)
	GameService.start()
	
	Pow.load()
	
	-- todo: generic for services
	EditorService.load()
	
	initUi()
	
	local sound_volume=Pow.arg.get("sound=",nil)
	
	if sound_volume~=nil then
		sound_volume=tonumber(sound_volume)
		MusicService.set_volume(sound_volume)
	end
	
end

love.update=function(dt)
	Pow.update(dt)
	local actor=GameState.get_controlled_entity()
	if actor~=nil then
		-- fun
		-- player.sprite="guest_star_yars"
		local x=actor.x
--		log("cam x:"..x)
		Pow.cam:setPosition(x, actor.y)	
	end
end

love.mousepressed=function(x,y,button,istouch)
	Pow.mousePressed(x,y,button,istouch)
end

love.resize=function(width, height)
	Pow.resize(width, height)
end

love.keypressed=function(key, scancode, isrepeat)
--	if key=="f3" then
--		BaseEntity.sx=BaseEntity.sx-0.1
--	end
	
--	if key=="f4" then
--		BaseEntity.sx=BaseEntity.sx+0.1
--	end
	
--	if key=="f5" then
--		BaseEntity.sy=BaseEntity.sy-0.1
--	end
	
--	if key=="f6" then
--		BaseEntity.sy=BaseEntity.sy+0.1
--	end
	
	
	
	Entity.keyPressed(key)
end


local _is_quitting=false

local doQuit=function()
	if _is_quitting then return end
	
	_is_quitting=true
	
	-- todo: generic for services
	EditorService.save()
	
	log("*** Quit pow ***")
	Pow.quit()
	
	log("*** Quit event ***")
	love.event.quit()
end

local startQuitTimer=function()
	log("startQuitTimer")
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
	
	-- bug: dual doQuit
	Event.process(event,doQuit)
	
	-- response: removed player entity
end

function love.textinput(text)
	Pow.console_toggle(text)
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

