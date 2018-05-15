local isDebug=arg[#arg] == "-debug"
if isDebug then require("mobdebug").start() end

LG=love.graphics

Gamera=require "lib/gamera/gamera"
Allen=require "lib/Allen/allen"

TSerial=require "lib/TSerial"
Serpent=require "lib/serpent/src/serpent"
Lume=require "lib/lume/lume"
Tween=require "lib/tween/tween"
Flux=require "lib/flux/flux"
Debug = require "lib/debug"

Const=require "data/const"
Config=require "data/config"

Util=require "tech/util"
Id=require "tech/id"

Event=require "core/event"
SortedList=require "lib/Wiki-Lua-Libraries/StandardLibraries/SortedList"
Entity=require "core/entity"

-- todo: mass-load (util loader to global space, or globalize method)
BaseEntity=require "entity/baseEntity"
Debugger=require "entity/debugger"
Editor=require "entity/editor"
Player=require "entity/player"
Actionbar=require "entity/actionbar"
Seed=require "entity/world/seed"
Grass=require "entity/world/grass"
Creature=require "entity/world/creature"
Pantera=require "entity/world/pantera"
Sheep=require "entity/world/sheep"
Alien=require "entity/world/alien"

Cam = Gamera.new(0,0,Config.levelWidth,Config.levelHeight)
local _cam=Cam

Session={
	frame=0,
	windowHeight=512,
	windowWidth=512,
	scale=4,
}


-- lowercase Globals - frequently used
log=Debug.log


-- declare globals
Fonts=nil -- init in load()
World=nil

local _debugger=Debugger.new()  ---EntityFactory.debugger()
local _editor=Editor.new()  ---EntityFactory.debugger()


local saveGame=function()
	Id.save()
	World.entities=Entity.getAll()
	local str=serialize(World)
	love.filesystem.write(Const.worldSaveFile, str)
end

local loadGame=function()
	Id.load()
	
	local info=love.filesystem.getInfo(Const.worldSaveFile)
	if info==nil then return false end
	local packed=love.filesystem.read(Const.worldSaveFile)
	World=deserialize(packed)
	assert(World)
	
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
	
	local isNewGame=Util.hasArg("new")
	--arg[#arg] == "-debug"
	
	if isNewGame or not loadGame() then newGame() end
	
	startUi()
	_cam:setScale(Session.scale)
	
	--love.graphics.setLineWidth(scale)
	
	-- todo later, no bar is ok
	--local actionBar=Actionbar.new()
	
	if Util.hasArg("sandbox") then require "sandbox" end
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


love.mousepressed=function(x,y,button,istouch)
	local gameX,gameY
		--gameX,gameY=x,y
	gameX,gameY=_cam:toWorld(x,y)
	
	log("Mouse pressed:"..xy(gameX,gameY).." btn:"..button)
	
	if button==1 then
		local moveEvent={}
		moveEvent.code="move"
		moveEvent.x=gameX-7
		moveEvent.y=gameY+1-World.player.height
		moveEvent.duration=2
		
		moveEvent.entity=World.player.entity
		moveEvent.entityId=World.player.id
		
		Event.new(moveEvent)
	elseif button==2 then	
		log("rmb:default action")


		-- wip editor
		
		if _editor.isActive then
			log("editor place item")
			Editor.placeItem(_editor)
			return
		end
		

		local player=World.player
		local activeEntity=player.activeFavorite
		if activeEntity==nil then
			log("use bare hands todo")
			return
		end
		
		-- todo: can we ask for mouse coord and get same one during frame?
		local entityCode=Entity.get(activeEntity.entity)
		if entityCode.use~=nil then
			log("use:"..activeEntity.entity)
			entityCode.use(activeEntity,gameX,gameY)
		else
			log("entity has no 'use' func:"..activeEntity.entity)
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
	log("keypressed:"..key)
	if key==Config.keyDebugger then
		toggleDebugger()
	elseif key==Config.keyEditor then
		toggleEditor()
	elseif key==Config.keyEditorNextItem then
		-- todo: editor listens for key when active
		Editor.nextItem(_editor)
	end
	
end

love.resize=function(width, height)
	Session.windowHeight=height
	Session.windowWidth=width

	
	_cam:setWindow(0,0,width,height)
end






love.quit=function()
	saveGame()
	return false
end
