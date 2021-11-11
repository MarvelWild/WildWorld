-- pow: love2d superpowers
-- framework extraction from "Wild World"
local _={}

local _gameScale=4

-- gamera instance
local _cam=nil

_.setGameScale=function(scale)
	local max=16
	local min=1
	
	scale=Pow.lume.clamp(scale,min,max)
	
	_gameScale=scale
	_cam:setScale(_gameScale)
end

_.zoomIn=function()
	local newGameScale=_gameScale+1
	
	_.setGameScale(newGameScale)
end

_.zoomOut=function()
	local newGameScale=_gameScale-1
	
	_.setGameScale(newGameScale)
end



_.saveDir="save/"
_.options={}
local _frame=0


	-- lib/powlov/pow
local pathOfThisFile = ...
-- 4 is a length(thisFile) - this file
local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-4) --(...):match("(.-)[^%.]+$")




-- todo: performance tests, this should be fast
_.get_frame=function()
	return _frame
end

_.set_frame=function(val)
	_frame=val
end




-- save id, logs
_.quit=function()
	_.id.save()
	_.debug.writeLogs()
	_.console.quit()
end

-- adds fields from parent to child
-- unused
--_.mergeModule=function(parent,child)
--	-- todo
--end



local initDeps=function(...)
	
	local dequePath=folderOfThisFile .. "/deps/cw-lua/deque/deque"
	_.deque=require(dequePath)
	
	-- multitool
	local lumePath=folderOfThisFile .. "/deps/lume/lume"
	_.lume=require(lumePath)

	-- string lib
	local allenPath=folderOfThisFile .. "/deps/Allen/allen"
	_.allen=require(allenPath)
	
	-- func style
	local mosesPath=folderOfThisFile .. "/deps/Moses/moses"
	_.moses=require(mosesPath)
	
	local debugPath=folderOfThisFile .. "/deps/debug"
	_.debug=require(debugPath)
	
	local tserialPath=folderOfThisFile .. "/deps/TSerial"
	_.tserial=require(tserialPath)
	
	local serpent_path=folderOfThisFile .. "/deps/serpent/src/serpent"
	_.serpent=require(serpent_path)
	
	-- it needs to be global under this name for self
	TSerial=_.tserial
	
	_.pack=TSerial.pack
	_.unpack=TSerial.unpack
	
	_.serialize=function(data)
		
		-- todo exclude function code. now it persists nop
		-- return _.serpent.dump(data) -- functions, not readable
		-- return _.serpent.block(data) -- same ref test fail
		return _.serpent.dump(data,
			{
				nocode=true,
--				valtypeignore={
--					"function"
--				},
				indent=" "
			}
		)
		
--		return TSerial.pack(data,true,true)
	end
	
	_.deserialize=function(data)
		local is_ok,deserialized=_.serpent.load(data)
		return deserialized
--		TSerial.unpack
	end
	
	
	local inspectPath=folderOfThisFile .. "/deps/inspect/inspect"
	_.inspect=require(inspectPath)
	
	-- особая точечная магия
	_.grease=require(folderOfThisFile .. "/deps/grease/grease.init")
	
	_.flux=require(folderOfThisFile .. "/deps/flux/flux")
	
	_.gamera=require(folderOfThisFile .. "/deps/gamera.gamera")
	
	_.arg=require(folderOfThisFile .. "/deps/arg.arg")
	_.arg.init(_)
	
		
	local timerLib=require(folderOfThisFile .. "/deps/timer/Timer")
	_.timerLib=timerLib
	
	-- example: Pow.timer:after(2, doQuit)
	_.timer=timerLib()
	
	_.hc=require(folderOfThisFile .. "/deps/HC/init")
	
	local console=require(folderOfThisFile .. "/deps/console/console")
	console.init(_)
	local console_toggle=console.toggle
	_.console=console
	_.console_toggle=console_toggle
end



initDeps(...)


-- Internalisation
local _lume=_.lume
local _allen=_.allen

local _getDirItems=love.filesystem.getDirectoryItems
local _getInfo=love.filesystem.getInfo


_cam=_.gamera.new(0,0,128,128)
_.cam=_cam

-- function(message,channelName)
_.log=_.debug.log

-- for self-debugging
_.internalLog=_.log
_.debug.pow=_

local _event

-- extra sublibs+staging
_.string={}
function _.string.split(str, div)
    assert(type(str) == "string" and type(div) == "string", "invalid arguments")
    local result = {}
    while true do
			if str==nil or str=="" then break end
			local pos1,pos2 = str:find(div)
			if not pos1 then
					result[#result+1] = str
					break
			end
			
			local part=str:sub(1,pos1-1)
			if part~="" then
				result[#result+1]=part
				str=str:sub(pos2+1)
			end
    end
    return result
end

-- example output: eachFile(entity/ui/,function: 0x27f57078)
_.logCall=function(...)
	local calling_func = debug.getinfo(2)
	local message=calling_func.name.."("
	
	local isFirst=true
	
	-- todo: resolve functions to names?
	for i=1,select('#',...) do
		if i>1 then message=message.."," end
		local currentParam=select(i,...)
		message=message..tostring(currentParam)
	end

	message=message..")"
	
	_.log(message)
end

_.normalizeDir=function(dir)
	if not _allen.endsWith(dir,'/') then 
		return dir.."/"
	else
		return dir
	end
end

-- recursively apply callback to each file in dir
_.eachFile=function(dir,callback)
	dir=_.normalizeDir(dir)
	
	-- _.logCall(dir,callback)
	
	local dirItems = _getDirItems(dir)
	for k,dirItem in ipairs(dirItems) do
		local itemPath=dir..dirItem
		local diInfo=_getInfo(itemPath)
		
		if diInfo.type=="file" then
			callback(itemPath)
		elseif diInfo.type=="directory" then
			_.eachFile(itemPath,callback)
		else
			-- symlink, or device, skip it (https://love2d.org/wiki/FileType)
			--_.log("unknown dirItem:"..dirItem)
		end
	end
	
end

_allen.cutTail=function(str, num)
	return string.sub(str,0,string.len(str)-num)
end

-- todo: all the tech/generic

local initModule=function(mod)
	if mod.init~=nil then
		mod.init(_)
	end
end

_.internals={}
_.internals.initModule=initModule

_.newCollision=function()
	--local result=require(folderOfThisFile.."/module/collision")
	local result=dofile("shared/lib/powlov/module/collision.lua")
	initModule(result)
	return result
end


-- extends lua, no pow integration
require(folderOfThisFile.."/module/lua")

_.id=require(folderOfThisFile.."/module/id")
initModule(_.id)

_.receiver=require(folderOfThisFile.."/module/net/receiver")
initModule(_.receiver)



_.entity=require(folderOfThisFile.."/module/entity/entity")
initModule(_.entity)
local _entity=_.entity


_.pointer=require(folderOfThisFile.."/module/entity/pointer")
-- это сервисная сущность+код
-- initModule(_.entity)

_.baseEntity=require(folderOfThisFile.."/module/entity/base_entity")


local drawGame=function(is_visible)
	_.entity.draw()
end


test_1=false

local width, height = love.graphics.getDimensions()
local lightmask = love.graphics.newCanvas(width, height)


_.draw=function()
	
	-- game
	love.graphics.push()
	_cam:draw(drawGame)
	love.graphics.pop()
	
	-- post effects
	
	-- night
	
--	if not test_1 then
----		test_1=true
		
--		love.graphics.push()
--		love.graphics.setColor(0.2,0.2,0.2, 0.5)
--		local w=love.graphics.getWidth()
--		local h=love.graphics.getHeight()
--		love.graphics.rectangle("fill",0,0,w,h)
		
--		-- todo: lights
--		--love.graphics.setColor(0,0,0, 1)
		
--		love.graphics.pop()
	
--	end

	-- night v2 later
	
	-- love.graphics.setBlendMode("multiply")
	
--	-- Draw lightmask --
--  love.graphics.setColor(255, 255, 255)
--  love.graphics.draw(lightmask, 0, 0)
--  love.graphics.setBlendMode("alpha")
	
	-- ui scale
	love.graphics.push()
	love.graphics.scale(2,2)
	Entity.draw_ui()
	love.graphics.pop()
	
	--unscaled ui
	love.graphics.scale(1,1)
	Entity.drawUnscaledUi()
end


-- NOTE: conect this to update
_.update=function(dt)
	_frame=_frame+1
	
	_.timer:update(dt)
	_.flux.update(dt)
	
	-- here unprocessed events from prev frame went to this one
	_event.earlyUpdate(dt)
	
	_entity.update(dt)
	

	
	-- here ... todo
	_entity.lateUpdate(dt)
end


-- todo: turn off for release
local tests=require(folderOfThisFile.."/tests")
tests.run(_)

_.setup=function(options)
	_.options=options
	_.net=require(folderOfThisFile.."/module/net/net")
	initModule(_.net)
	
	_event=_.net.event

	_.server=_.net.server
	_.client=_.net.client

	local saveDirInfo=love.filesystem.getInfo(_.saveDir)
	if saveDirInfo==nil then
		love.filesystem.createDirectory(_.saveDir)
	end
	
	
	
end


_.load=function()
	
	-- todo: config scale, world size
	_cam:setScale(_gameScale)
	_cam:setWorld(0,0,4096,4096)
end

_.getWorldCoords=function(screenX,screenY)
	return _cam:toWorld(screenX,screenY)
end

_.getScreenCoords=function(worldX,worldY)
	return _cam:toScreen(worldX,worldY)
end

-- for 2x scaled ui
-- todo: dyn scale
_.get_ui_coords=function(worldX,worldY)
	local sx,sy=_.getScreenCoords(worldX,worldY)
	return sx/2,sy/2
end


-- in world coords
_.getMouseXY=function()
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	local gameX,gameY=_.getWorldCoords(x,y)
	return gameX,gameY
end



_.resize=function(width, height)
	_cam:setWindow(0,0,width,height)
end





_.mousePressed=function(x,y,button,istouch)
	local gameX,gameY
	gameX,gameY=Pow.getWorldCoords(x,y)
	
	Entity.mousePressed(gameX,gameY,button,istouch)
end

_.registerGlobal=function(name,value)
	assert(_G[name]==nil, "global exists:"..name)
	_G[name]=value
end

-- entity\world\panther.lua -> panther
_.currentFile=function()
    local source = debug.getinfo(2, "S").source
    if source:sub(1,1) == "@" then
        return source:sub(2):match("^.+/(.+)$"):sub(1,-5)
    else
        error("Caller was not defined in a file", 2)
    end
end


-- Inhibit Regular Expression magic characters ^$()%.[]*+-?)
local strPlainText=function(strText)
    -- Prefix every non-alphanumeric character (%W) with a % escape character, 
    -- where %% is the % escape, and %1 is original character
    return strText:gsub("(%W)","%%%1")
end -- function strPlainText

_.replace=function(str,old,new)
	local s1=strPlainText(old)
	local s2=strPlainText(new)
	return str:gsub(s1,s2)
end




-- multi-file module, members are merged
-- example: Cell=multirequire("shared/world/cell","world/cell")
_.multirequire=function(...)
	local params={...}
	local result=nil
	for k,path in ipairs(params) do
		if result==nil then
			result=require(path)
		else
			result=_lume.merge(result, require(path))
		end
	end
	
	return result
end

--todo : sort

-- path example: entity/world
_.is_dir=function(path)
	local info = love.filesystem.getInfo(path)
	return info and info.type=="directory"
end

_.loadEntity=function(path)
	local entity=require(path)
	
	log("loadEntity:"..path,"verbose")
	if entity==true then
		log("error:entity not loaded:"..path)
	end
	
	local globalVarName=Pow.allen.capitalizeFirst(entity.entity_name)
	Pow.registerGlobal(globalVarName, entity)
	Entity.addCode(entity.entity_name,entity)
	if entity.load~=nil then entity.load() end
	
	return entity
end

-- рекурсивно
_.loadEntitiesFromDir=function(dirName)
	local result={}
	local dirItems=love.filesystem.getDirectoryItems(dirName)
	for k,fileName in ipairs(dirItems) do
		
		local file_path=dirName.."/"..fileName
		
--		-- is dir check
--		local fs_info = love.filesystem.getInfo( file_path )
--		if fs_info.type=="file" then
		if Pow.allen.endsWith(fileName, ".lua") then
			local entity_name=Pow.replace(fileName,".lua","")
			local entityPath=dirName.."."..entity_name
		
			local entity=_.loadEntity(entityPath)
			table.insert(result,entity)
		elseif Pow.is_dir(file_path) then
			
			-- Error: main.lua:75: attempt to call global 'loadEntitiesFromDir' (a nil value)
			local sub_result=_.loadEntitiesFromDir(file_path)
			table.append(result,sub_result)
		end -- if not lua
--		end -- if file
	end
	return result
end



_.write_object=function(key,object)
	local serialized=_.serialize(object)
	local path=_.saveDir..key
	love.filesystem.write(path, serialized)
end


-- десериализовать из сейва
_.read_object=function(key)
	local path=_.saveDir..key
	local serialized=love.filesystem.read(path)
	if not serialized then return nil end
	local result=_.deserialize(serialized)
	return result
end


return _