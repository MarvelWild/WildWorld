-- pow: love2d superpowers
-- framework extraction from "Wild World"
local _={}


local initDeps=function(...)


	-- lib/powlov/pow
	local pathOfThisFile = ...
	
	-- 4 is a length(thisFile) - this file
	local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-4) --(...):match("(.-)[^%.]+$")

	-- multitool
	local lumePath=folderOfThisFile .. "/deps/lume/lume"
	_.lume=require(lumePath)

	-- string lib
	local allenPath=folderOfThisFile .. "/deps/Allen/allen"
	_.allen=require(allenPath)
	
	-- func style
	local mosesPath=folderOfThisFile .. "/deps/Moses/moses"
	_.moses=require(mosesPath)
end

initDeps(...)


-- Internalisation
local _lume=_.lume
local _allen=_.allen
local _getDirItems=love.filesystem.getDirectoryItems
local _getInfo=love.filesystem.getInfo


_.log=function(message)
	-- print(message)
end



_.logCall=function(...)
	local calling_func = debug.getinfo(2)
	local message=calling_func.name.."("
	
	local isFirst=true
	
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
	
	_.logCall(dir,callback)
	
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

-- todo: logging and all the tech/generic


return _