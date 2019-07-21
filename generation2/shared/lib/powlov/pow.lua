-- pow: love2d superpowers
-- framework extraction from "Wild World"
local _={}

_.saveDir="save/"
_.options={}
local _frame=0

	-- lib/powlov/pow
local pathOfThisFile = ...
-- 4 is a length(thisFile) - this file
local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-4) --(...):match("(.-)[^%.]+$")




_.getFrame=function()
	return _frame
end




-- save id, logs
_.quit=function()
	_.id.save()
	_.debug.writeLogs()
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
	
	-- it needs to be global under this name for self
	TSerial=_.tserial
	
	_.pack=TSerial.pack
	_.unpack=TSerial.unpack
	
	_.serialize=function(data)
		return TSerial.pack(data,true,true)
	end
	
	_.deserialize=TSerial.unpack
	
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
end

initDeps(...)


-- Internalisation
local _lume=_.lume
local _allen=_.allen

local _getDirItems=love.filesystem.getDirectoryItems
local _getInfo=love.filesystem.getInfo


local _cam=_.gamera.new(0,0,128,128)
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
-- single instances

-- extends lua, no pow integration
require(folderOfThisFile.."/module/lua")

_.id=require(folderOfThisFile.."/module/id")
initModule(_.id)

_.receiver=require(folderOfThisFile.."/module/net/receiver")
initModule(_.receiver)



_.entity=require(folderOfThisFile.."/module/entity/entity")
initModule(_.entity)
local _entity=_.entity

_.baseEntity=require(folderOfThisFile.."/module/entity/base_entity")


local drawGame=function()
	_.entity.draw()
end


_.draw=function()
	_cam:draw(drawGame)
	
	-- ui scale
	love.graphics.scale(2,2)
	Entity.drawUi()
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
	_cam:setScale(4)
	_cam:setWorld(0,0,4096,4096)
end

_.getWorldCoords=function(screenX,screenY)
	return _cam:toWorld(screenX,screenY)
end


_.resize=function(width, height)
	_cam:setWindow(0,0,width,height)
end




return _