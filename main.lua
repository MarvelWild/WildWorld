local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

_traceback=debug.traceback
LG=love.graphics
LK=love.keyboard

Gamera=require "lib/gamera/gamera"
Allen=require "lib/Allen/allen"

TSerial=require "lib/TSerial"
Serpent=require "lib/serpent/src/serpent"
Lume=require "lib/lume/lume"
Tween=require "lib/tween/tween"

--tweening
Flux=require "lib/flux/flux"
TimerLib=require "lib/timer/Timer"
Timer=TimerLib()
Debug = require "lib/debug"
Inspect=require "lib/inspect/inspect"
Debug.useFile=true

-- collisions
Hc=require "lib/HC/init"


Const=require "data/const"
Config=require "data/config"

Arg=require "lib/arg/arg"
Util=require "tech/util"

-- global exports (frequently used)
table_removeByVal=Util.table_removeByVal
table_delete=Util.table_delete
table_isEmpty=Util.table_isEmpty
loadScripts=Util.loadScripts
xy=Util.xy
xywh=Util.xywh
serialize=Util.serialize
deserialize=Util.deserialize


Id=require "tech/id"

-- удивительно, но точка - это важно, иначе не находится core
Grease=require 'lib/grease/grease.init'


SortedList=require "lib/Wiki-Lua-Libraries/StandardLibraries/SortedList"
Entity=require "core/entity"
E=Entity

-- todo: mass-load (util loader to global space, or globalize method)
BaseEntity=require "entity/baseEntity"
Debugger=require "entity/debugger"
Actionbar=require "entity/actionbar"
PlayerUi=require "entity/player_ui"

ClientAction=require 'client/action'

Tile=require "res/tile"

-- depend on Tile
TilesView=require 'view/tiles'


Cam = Gamera.new(0,0,128,128)
local _cam=Cam

Session=require "core/session"


Session.isClient=Util.hasArg("c")
Session.isServer=not Session.isClient
Session.serverBindAddress=Arg.get("bind=","*")

local setClientLogin=function()
	local loginPos= Lume.find(arg, "login")
	local login
	if loginPos then
		login=arg[loginPos+1]
	end
	
	if login then
		Session.login=login
	else
		Session.login="client1"
	end

end


if Session.isClient then
	setClientLogin()
	love.filesystem.setIdentity("WiW_Client_"..Session.login)
	
else
	-- server-only init
	love.window.setPosition(20,100)
end

-- requires session
Event=require "core/event"

-- lowercase Globals - frequently used
log=Debug.log
pack=TSerial.pack
draw=LG.draw
dbgCtxIn=Debug.enterContext
dbgCtxOut=Debug.exitContext
_ets=Entity.toString
local _cursorImg=nil

log("*** Start *** "..Util.getTimestamp())

-- declare globals
Fonts=nil -- init in load()


local _debugger=Debugger.new()  ---EntityFactory.debugger()
local _editor=nil
local _profiler=nil


local saveGame=function()
	Id.save()
	Universe.save()
	Player.save()
end

local loadGame=function()
	log("loadGame")
	
	Id.load()
	
	
	local isLoaded=Player.load()
	if Session.isServer then
		isLoaded=Universe.load()
	
		if isLoaded then
			-- client does it later, after player registered
			ClientAction.setWorld(CurrentPlayer.worldName)
		end
	end

	return isLoaded
end

local newGame=function()
	log("new game")
	-- client doesnt need entire universe
	if Session.isServer then
		CurrentUniverse=Universe.new()
		local initWorlds=require "data/initworlds"
		initWorlds()
	end
		
	CurrentPlayer=Player.new()
	

	Entity.setActive(CurrentPlayer,true)
	Player.giveStarterPack(CurrentPlayer)
	
	if Session.isServer then
		ClientAction.setWorld(CurrentPlayer.worldName)
	end
end


local startUi=function()
	local actionBar=Actionbar.new()
	Entity.setActive(actionBar,true)
	
	local playerUi=PlayerUi.new()
	Entity.setActive(playerUi,true)
end

local preloadImages=function()
	local tmp=Img.dracon
end

local startClient=function()
	log("starting client")
	
	love.window.setTitle(love.window.getTitle().." | client | "..Session.login)
	ClientEntity=Client.new()
	Client.connect(ClientEntity)
end

local startServer=function()
	log("starting server")
	love.window.setTitle(love.window.getTitle().." | server "..Session.serverBindAddress..":"..Session.port)
	ServerEntity=Server.new()
end




local testHc=function()
	-- collision lib understanding
	-- http://hc.readthedocs.org
	
	local rect1 = Hc.rectangle(200,400,400,20)
	local pointInside = Hc.point(201,401)
	local pointOutside = Hc.point(2201,401)
	
	local c1=pointInside:collidesWith(rect1)
	local c2=pointOutside:collidesWith(rect1)
	assert(c1==true)
	assert(c2==false)
	
	Hc.remove(rect1)
	Hc.remove(pointInside)
	Hc.remove(pointOutside)
	
	
end

love.load=function()
	Id.init()
	Fonts={}
	Fonts.main=LG.getFont()
	Fonts.chat=love.graphics.newFont("res/LiberationSans-Regular.ttf", 18)
	
	love.graphics.setFont(Fonts.chat)
	love.graphics.setDefaultFilter( "nearest", "nearest" )
	
	
	-- active for draw only
	--love.graphics.scale(scale,scale)
	Img=require "res/img"
		
	preloadImages()
	
	-- todo: autoload
	
	World=require "entity/world"
	Universe=require "entity/universe"
	
	GrowableBehaviour=require "entity/behaviour/growable"
	DrawableBehaviour=require "entity/behaviour/drawable"
	MountableBehaviour=require "entity/behaviour/mountable"	
	DamageableBehaviour=require "entity/behaviour/damageable"	
	Standing=require "entity/behaviour/standing"	
	Taggable=require "entity/behaviour/taggable"	
	
	Player=require "entity/player"
	Seed=require "entity/world/seed"
	Grass=require "entity/world/grass"
	Flower=require "entity/world/flower"
	Creature=require "entity/world/creature"
	Pantera=require "entity/world/pantera"
	Zebra=require "entity/world/zebra"
	Dragon=require "entity/world/dragon"
	Pegasus=require "entity/world/pegasus"
	Sheep=require "entity/world/sheep"
	SheepBlack=require "entity/world/sheep_black"
	HorseSmall=require "entity/world/horse_small"
	Camel=require "entity/world/camel"
	Elephant=require "entity/world/elephant"
	Jiraffe=require "entity/world/jiraffe"
	LionFemale=require "entity/world/lion_female"
	Tiger=require "entity/world/tiger"
	Zombie=require "entity/world/zombie"
	Alien=require "entity/world/alien"
	BirchSapling=require "entity/world/birch_sapling"
	Cauldron=require "entity/world/cauldron"
	Boombox=require "entity/world/boombox"
	Bucket=require "entity/world/bucket"
	BirchTree=require "entity/world/birch_tree"
	FirTree=require "entity/world/fir_tree"
	AppleTree=require "entity/world/apple_tree"
	

	
	Server=require "entity/server"
	Client=require "entity/client"
	Editor=require "entity/editor"
	Pointer=require "entity/pointer"
	
	Collision=require "core/collision"
	
	Profiler=require "entity/profiler"
	_editor=Editor.new()  ---EntityFactory.debugger()
	_profiler=Profiler.new()

	
	--love.graphics.setLineWidth(scale)
	
	-- todo later, no bar is ok
		
	CurrentWorld=nil
	CurrentPlayer=nil
		
	if Util.hasArg("sandbox") then require "sandbox" end
	if Session.isServer then
		CurrentUniverse=nil
		startServer() 
	end
	
	local isNewGame=Util.hasArg("new")


	
	--if Session.isServer then
	if isNewGame then 
		newGame()
	elseif not loadGame() then
		newGame()
	end
	--end
	
	-- load first, so we have a player
	if Session.isClient then
		startClient() 
	end
	
	startUi()
	_cam:setScale(Session.scale)
	
	testHc()
	
	_cursorImg=Img.cusror_default
	
--[[ My intel 4000	
	anisotropy = 16,
  canvasmsaa = 8,
  cubetexturesize = 16384,
  multicanvas = 8,
  pointsize = 255,
  texturelayers = 2048,
  texturesize = 16384,
  volumetexturesize = 2048	
]]--	
--	local limits = love.graphics.getSystemLimits()
--	log("Graphic limits:"..Inspect(limits))
end


--local drawTile2=function(img,x,y)
--	draw(img,x,y)
--end


--local drawTile=function(tileNumber,x,y)
--	-- local imgId="level_main/tile"..tileNumber
	
--	local img=Tile[tileNumber]
	
--	if img==nil then
--		local a=1
--		log("no tile:"..tileNumber)
--	else
--		drawTile2(img,x,y)
--	end
	
	
--	--LG.draw(img,x,y)
--end


local drawTiles=TilesView.draw

local doDraw=function(l,t,w,h)
	local world=CurrentWorld
	if world==nil then
		LG.print("no world loaded",2,30)
		return
	end
	
	
	-- todo: build draw function on setWorld instead of this checks
	
	--log("doDraw("..l..","..t..","..w..","..h)
	if world.tileMapName~=nil then
		drawTiles(l,t,w,h)
	end
	
	if world.bgSprite~=nil then
		local sprite=Img["level/"..world.bgSprite]
		draw(sprite)
	end
	
	Entity.draw()
	Collision.draw()
end


love.draw=function()
	-- active for draw only
	local scale=Session.uiScale

--	love.graphics.scale(1,0.5)
	_cam:draw(doDraw)
	
	-- cam has internal scale
	
	-- 1x scaled ui (debugger)
	
	Entity.drawScaledUi()
	
	-- double scale is trouble (first applied, second not)
	
	
	-- why every draw call? for ui
	love.graphics.scale(scale,scale)
	--love.graphics.scale(1,1)
	
	Entity.drawUi()
	
	if Session.hasErrors then
		LG.print("ERROR")
	end
	
	if Session.hasWarnings then
		LG.print("WARN")
	end
	

	local mx=love.mouse.getX()/scale
	local my=love.mouse.getY()/scale
	draw(_cursorImg,mx,my)
	love.mouse.setVisible(false)
end

love.update=function(dt)
	Session.frame=Session.frame+1
	Flux.update(dt)
	Timer:update(dt)
	
	Entity.update(dt)
	Event.update(dt)
	
	if Session.frame%60==0 then
		Entity.slowUpdate(dt)
	end
	

	if CurrentPlayer~=nil then
		_cam:setPosition(Entity.getCenter(CurrentPlayer))
	end
	--log("cam pos:".._cam:getPosition())
end

local selectObject=function(entity)
	if Session.selectedEntity==entity then
		if entity~=nil then
			log("already selected")
		end
		
		return
	end
	
	Session.selectedEntity=entity
	
	log("Selected:"..Entity.toString(entity))
end


local selectObjectByCoord=function(x,y)
	-- log("selectObject:"..xy(x,y))
	local entities=Collision.getAtPoint(x,y)
	
	local k,first
	if entities~=nil then
		k,first=next(entities)
	end
	
	if first==nil then
		log("nothing to select")
	end
	
	-- todo: cycle all
	selectObject(first)
end


love.mousepressed=function(x,y,button,istouch)
	local gameX,gameY
		--gameX,gameY=x,y
	gameX,gameY=_cam:toWorld(x,y)
	
	log("Mouse pressed:"..xy(gameX,gameY).." btn:"..button)
	
	if button==1 then
		if LK.isDown("lshift") then
			selectObjectByCoord(gameX,gameY)
			return
		end
		ClientAction.move(CurrentPlayer,gameX,gameY)
	elseif button==2 then	
		log("rmb:default action")

		if _editor.isActive then
			log("editor place item")
			local item=Editor.placeItem(_editor)
			-- Entity.transferToServer({item})
			return
		end
		

		local player=CurrentPlayer
		local activeEntity=player.activeFavorite
		if activeEntity==nil then
			log("use bare hands todo")
			return
		end
		
		local entity=activeEntity-- Entity.find(activeEntity.entity, activeEntity.id,Session.login)
		local entityCode=Entity.get(activeEntity.entity)
		if entityCode.use~=nil then
			log("use:"..entity.entity)
			-- тут внутри создастся ивент
			entityCode.use(entity,gameX,gameY)
		else
			log("entity has no 'use' func:"..entity.entity)
		end
	end
end

local toggleDebugger=function()
	Entity.setActive(_debugger,not _debugger.isActive)
end

local toggleEditor=function()
	Entity.setActive(_editor,not _editor.isActive)
end

local toggleProfiler=function()
	Entity.setActive(_profiler,not _profiler.isActive)
end


local pickup=function()
	log("pickup")
	local extraRange=10
	
	local player=CurrentPlayer
	
	local doubleRange=extraRange+extraRange
	local x=player.x-extraRange
	local y=player.y-extraRange
	local w=player.w+doubleRange
	local h=player.h+doubleRange
	
	
	local candidateEntities=Collision.getAtRect(x,y,w,h)
	
	if not candidateEntities then
		log("nothing to pick up")
		return
	end
	
	for k,candidate in pairs(candidateEntities) do
		if Entity.canPickup(candidate) then
			ClientAction.pickup(candidate)
			break
		end
	end
end



love.keypressed=function(key,unicode)
	log("keypressed:"..key.." u:"..unicode, "keyboard")
	
	local isProcessedByEntities=Entity.keypressed(key,unicode)
	if isProcessedByEntities then
		log("key processed by entities")
		return
	end
	
	
	if key==Config.keyDebugger then
		Debug.writeLogs()
		toggleDebugger()
	elseif key==Config.keyEditor then
		toggleEditor()
	elseif key==Config.keyProfiler then
		toggleProfiler()		
	elseif key==Config.keyEditorNextItem then
		-- todo: editor listens for key when active
		Editor.nextItem(_editor)
	elseif key==Config.keyEditorPrevItem then
		-- todo: editor listens for key when active
		Editor.prevItem(_editor)		
	elseif key=="home" then
		-- change player sprite for fun
		local isFound=false
		local first=nil
		local currSprite=Img[CurrentPlayer.spriteName]
		local nextSpriteName=nil
		for k,v in pairs(Img) do
			local t=type(v)
			if t=="userdata" then 
				if first==nil then 
					if not string.find(k,"tile") then
						first=k
					end
				end
				
				if v==currSprite then
					isFound=true
				elseif isFound then
					if not string.find(k,"tile") then
						nextSpriteName=k
						break
					end
				end
			end
		end
		
		if nextSpriteName==nil then nextSpriteName=first end
		
		Entity.setSprite(CurrentPlayer, nextSpriteName)
	elseif key==Config.keyMount then
		ClientAction.toggleMount(CurrentPlayer)
	elseif key=="z" then
		local nextSprite
		while true do
			local rnd=Lume.random()
			log("roll:"..rnd)
			if rnd > 0.9 then
				nextSprite="bee"
			elseif rnd > 0.4 then
				nextSprite="player"
			else
				nextSprite="girl"
			end
			
			if CurrentPlayer.spriteName~=nextSprite then 
				break
			end
			
		end
		
		Entity.setSprite(CurrentPlayer, nextSprite)
	elseif key==Config.keyItemPickup then
		pickup()
	elseif key==Config.keyDeleteEntity then
		ClientAction.deleteSelected()
	elseif key=="kp+" then
		Session.scale=Session.scale+1
		_cam:setScale(Session.scale)
	elseif key=="kp-" then
		if Session.scale>=2 then
			Session.scale=Session.scale-1		
			_cam:setScale(Session.scale)
		end
	end
	
end

love.resize=function(width, height)
	Session.windowHeight=height
	Session.windowWidth=width

	
	_cam:setWindow(0,0,width,height)
end




local doQuit=function()
	saveGame()
	
	log("*** Quit ***")
	Debug.writeLogs()
	
	love.event.quit()
end

local afterLogoff=function()
	log("after logoff")
	doQuit()
	

end


local startQuitTimer=function()
	log("startQuitTimer")
	Timer:after(2, doQuit)
end


local _isLogoff=false

local logoff=function()
	log("logoff")
	_isLogoff=true

	startQuitTimer()
	
	local event=Event.new()
	event.code="logoff"
	event.target="server" 
	
	-- todo react to event
end


love.quit=function()
	if not _isLogoff and Session.isClient then
		logoff()
		
		-- Abort quitting. If true, do not close the game.
		return true
	end
	
	doQuit()
	
	
	
	
	return false
end


love.mousemoved=function( x, y, dx, dy, istouch )
	
end
