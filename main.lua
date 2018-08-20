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
Debug = require "lib/debug"
Inspect=require "lib/inspect/inspect"
Debug.useFile=true

-- collisions
Hc=require "lib/HC/init"


Const=require "data/const"
Config=require "data/config"

Util=require "tech/util"
Id=require "tech/id"

-- удивительно, но точка - это важно, иначе не находится core
Grease=require 'lib/grease/grease.init'


SortedList=require "lib/Wiki-Lua-Libraries/StandardLibraries/SortedList"
Entity=require "core/entity"

-- todo: mass-load (util loader to global space, or globalize method)
BaseEntity=require "entity/baseEntity"
Debugger=require "entity/debugger"
Actionbar=require "entity/actionbar"

Collision=require "core/collision"
ClientAction=require 'client/action'
TilesView=require 'view/tiles'



Cam = Gamera.new(0,0,Config.levelWidth,Config.levelHeight)
local _cam=Cam

Session=require "core/session"


Session.isClient=Util.hasArg("c")
Session.isServer=not Session.isClient

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
	love.filesystem.setIdentity("ULR_Client_"..Session.login)
	
else
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
World=nil

local _debugger=Debugger.new()  ---EntityFactory.debugger()
local _editor=nil
local _profiler=nil


local saveGame=function()
	Id.save()
	World.entities=Entity.getSaving()
	local str=serialize(World)
	love.filesystem.write(Const.worldSaveFile, str)
end

local loadGame=function()
	log("loadGame")
	Id.load()
	
	local info=love.filesystem.getInfo(Const.worldSaveFile)
	if info==nil then return false end
	local packed=love.filesystem.read(Const.worldSaveFile)
	World=deserialize(packed)
	assert(World)
	
	if Session.isClient then
		
--		for k,entity in pairs(World.entities) do
--			if entity.entity=="Player" then
--				World.entities={}
--				table.insert(World.entities,entity)
--				break
--			end
--		end
		
		local newEntities={}
		for k,entity in pairs(World.entities) do
			if entity.entity=="Player" or entity.entity=="Seed" then
				table.insert(newEntities,entity)
			end
		end
		
		World.entities=newEntities
	end
	
	Entity.registerWorld()
	
	return true
end

local newGame=function()
	World={}
	World.player=Player.new()
	Entity.setActive(World.player,true)
	Player.giveStarterPack(World.player)
end


local startUi=function()
	local actionBar=Actionbar.new()
	Entity.setActive(actionBar,true)
end

local preloadImages=function()
	local tmp=Img.dracon
end

local startClient=function()
	log("starting client")
	-- todo: load player only. 
	if not loadGame() then newGame() end
	love.window.setTitle(love.window.getTitle().." | client | "..Session.login)
	ClientEntity=Client.new()
	Client.connect(ClientEntity)
	
	-- newGame()
end

local startServer=function()
	log("starting server")
	love.window.setTitle(love.window.getTitle().." | server")
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
	Tile=require "res/tile"
	
	preloadImages()
	
	GrowableBehaviour=require "entity/behaviour/growable"
	DrawableBehaviour=require "entity/behaviour/drawable"
	MountableBehaviour=require "entity/behaviour/mountable"	
	
	Player=require "entity/player"
	Seed=require "entity/world/seed"
	Grass=require "entity/world/grass"
	Creature=require "entity/world/creature"
	Pantera=require "entity/world/pantera"
	Dragon=require "entity/world/dragon"
	Pegasus=require "entity/world/pegasus"
	Sheep=require "entity/world/sheep"
	SheepBlack=require "entity/world/sheep_black"
	HorseSmall=require "entity/world/horse_small"
	Zombie=require "entity/world/zombie"
	Alien=require "entity/world/alien"
	BirchSapling=require "entity/world/birch_sapling"
	Cauldron=require "entity/world/cauldron"
	Bucket=require "entity/world/bucket"
	BirchTree=require "entity/world/birch_tree"
	FirTree=require "entity/world/fir_tree"
	AppleTree=require "entity/world/apple_tree"
	

	
	Server=require "entity/server"
	Client=require "entity/client"
	Editor=require "entity/editor"
	Profiler=require "entity/profiler"
	_editor=Editor.new()  ---EntityFactory.debugger()
	_profiler=Profiler.new()

	
	--love.graphics.setLineWidth(scale)
	
	-- todo later, no bar is ok
		
	if Util.hasArg("sandbox") then require "sandbox" end
	if Session.isServer then startServer() end
	
	local isNewGame=Util.hasArg("new")

	if Session.isClient then
		startClient() 
	elseif isNewGame or not loadGame() then 
		newGame()
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

local function doDraw(l,t,w,h)
	--log("doDraw("..l..","..t..","..w..","..h)
	drawTiles(l,t,w,h)
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
	
	Entity.update(dt)
	Event.update(dt)
	
	if Session.frame%60==0 then
		Entity.slowUpdate(dt)
	end
	

	_cam:setPosition(Entity.getCenter(World.player))
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
		ClientAction.move(World.player,gameX,gameY)
	elseif button==2 then	
		log("rmb:default action")

		if _editor.isActive then
			log("editor place item")
			local item=Editor.placeItem(_editor)
			-- Entity.transferToServer({item})
			return
		end
		

		local player=World.player
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
	
	local player=World.player
	
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
		
		local isFound=false
		local first=nil
		local currSprite=Img[World.player.spriteName]
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
		
		Entity.setSprite(World.player, nextSpriteName)
	elseif key==Config.keyMount then
		ClientAction.toggleMount(World.player)
	elseif key=="z" then
		local rnd=Lume.random()
		log("roll:"..rnd)
		if rnd > 0.9 then
			Entity.setSprite(World.player, "bee")
		elseif rnd > 0.8 then
			Entity.setSprite(World.player, "dragon")
		elseif rnd > 0.4 then
			Entity.setSprite(World.player, "player")
		else
			Entity.setSprite(World.player, "girl")
		end
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






love.quit=function()
	saveGame()
	
	log("*** Quit ***")
	Debug.writeLogs()
	return false
end


love.mousemoved=function( x, y, dx, dy, istouch )
	
end
