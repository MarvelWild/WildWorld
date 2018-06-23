local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

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

Event=require "core/event"
SortedList=require "lib/Wiki-Lua-Libraries/StandardLibraries/SortedList"
Entity=require "core/entity"

-- todo: mass-load (util loader to global space, or globalize method)
BaseEntity=require "entity/baseEntity"
Debugger=require "entity/debugger"
Actionbar=require "entity/actionbar"

Collision=require "core/collision"



Cam = Gamera.new(0,0,Config.levelWidth,Config.levelHeight)
local _cam=Cam

Session={
	frame=0,
	windowHeight=512,
	windowWidth=512,
	scale=4,
	isClient=false,
	login="defaultLogin",
	selectedEntity=nil,
	isOnHorse=true, -- tmp kiss
}

Session.isClient=Util.hasArg("c")
Session.isServer=not Session.isClient

if Session.isClient then
	love.filesystem.setIdentity("ULR_Client")
	Session.login="client1"
else
	love.window.setPosition(20,100)
end

-- lowercase Globals - frequently used
log=Debug.log
pack=TSerial.pack

log("*** Start ***")


-- declare globals
Fonts=nil -- init in load()
World=nil

local _debugger=Debugger.new()  ---EntityFactory.debugger()
local _editor=nil


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
	Player.giveStarterPack(World.player)
end


local startUi=function()
	local actionBar=Actionbar.new()
end

local preloadImages=function()
	local tmp=Img.dracon
end

local startClient=function()
	log("starting client")
	-- todo: load player only. 
	if not loadGame() then newGame() end
	love.window.setTitle(love.window.getTitle().." | client")
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
	
	Player=require "entity/player"
	Seed=require "entity/world/seed"
	Grass=require "entity/world/grass"
	Creature=require "entity/world/creature"
	Pantera=require "entity/world/pantera"
	Sheep=require "entity/world/sheep"
	Alien=require "entity/world/alien"
	BirchSapling=require "entity/world/birch_sapling"
	Cauldron=require "entity/world/cauldron"
	Bucket=require "entity/world/bucket"
	BirchTree=require "entity/world/birch_tree"
	
	Server=require "entity/server"
	Client=require "entity/client"
	Editor=require "entity/editor"
	_editor=Editor.new()  ---EntityFactory.debugger()

	
	--love.graphics.setLineWidth(scale)
	
	-- todo later, no bar is ok
	--local actionBar=Actionbar.new()
	
	if Util.hasArg("sandbox") then require "sandbox" end
	if Util.hasArg("s") then startServer() end
	
	local isNewGame=Util.hasArg("new")

	if Session.isClient then
		startClient() 
	elseif isNewGame or not loadGame() then 
		newGame()
	end
	
	startUi()
	_cam:setScale(Session.scale)
	
	testHc()
end




-- left, top
local drawTiles=function(l,t,w,h)
	-- log("drawTiles("..l..","..t..","..w..","..h)
	
	
	local startY=Lume.round(t,TILE_SIZE)-TILE_SIZE
	local endY=startY+h+TILE_SIZE+TILE_SIZE
	
	local startX=Lume.round(l,TILE_SIZE)-TILE_SIZE
	local endX=startX+w+TILE_SIZE+TILE_SIZE
	
	if startY<0 then startY=0 end
	if startX<0 then startX=0 end
	local max=4096-TILE_SIZE
	if endX>max then endX=max end
	if endY>max then endY=max end
	
--	log("drawTiles("..l..","..t..","..w..","..h.." x:"..xy(startX,endX))
	
	for y=startY,endY,TILE_SIZE do
		for x=startX,endX,TILE_SIZE do
			local tileX=x/TILE_SIZE
			local tileY=y/TILE_SIZE
			--opt precalc tiles
			local tileNumber=tileX+((tileY)*128)
			local imgId="level_main/tile"..tileNumber
			local img=Img[imgId]
			
			LG.draw(img,x,y)
		end
	end
end

local function doDraw(l,t,w,h)
	--log("doDraw("..l..","..t..","..w..","..h)
	drawTiles(l,t,w,h)
	Entity.draw()
end


love.draw=function()
	-- active for draw only
	local scale=Session.scale

--	love.graphics.scale(1,0.5)
	_cam:draw(doDraw)
	
	-- cam has internal scale
	
	-- 1x scaled ui (debugger)
	
	Entity.drawScaledUi()
	
	-- double scale is trouble (first applied, second not)
	love.graphics.scale(scale,scale)
	--love.graphics.scale(1,1)
	
	Entity.drawUi()
end

love.update=function(dt)
	Session.frame=Session.frame+1
	Flux.update(dt)
	
	Entity.update(dt)
	Event.update(dt)
	
	_cam:setPosition(World.player.x, World.player.y)
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
		
		local moveEvent=Event.new()
		moveEvent.code="move"
		moveEvent.x=gameX-7
		moveEvent.y=gameY+1-World.player.h
		moveEvent.duration=2
		
		moveEvent.entity=World.player.entity
		moveEvent.entityId=World.player.id
		
		
	elseif button==2 then	
		log("rmb:default action")

		if _editor.isActive then
			log("editor place item")
			local item=Editor.placeItem(_editor)
			Entity.transferToServer({item})
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



love.keypressed=function(key,unicode)
	log("keypressed:"..key.." u:"..unicode)
	
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
	elseif key==Config.keyEditorNextItem then
		-- todo: editor listens for key when active
		Editor.nextItem(_editor)
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
		
		Entity.setSprite(World.player, "nextSpriteName")
	elseif key=="x" then
		log("horse mount")
		Session.isOnHorse=not Session.isOnHorse
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
