-- registered as global Id


local _={}

local _lastIdByName={}

local savePath

_.init=function(saveDir)
	if saveDir==nil then saveDir="" end
	
	savePath=saveDir.."id"
end


_.new=function(name)
	local prevId=_lastIdByName[name]
	if prevId==nil then prevId=0 end
	local result=prevId+1
	
	_lastIdByName[name]=result
	
	return result
end


_.save=function()
	local serialized=serialize(_lastIdByName)
	love.filesystem.write(savePath, serialized)
	
end

_.load=function()
	--	if _lastIdByName~=nil then log("warn:id alrea") its ok
	local serialized=love.filesystem.read(savePath)
	
	if serialized~=nil then
		_lastIdByName=deserialize(serialized)
	else
		_lastIdByName={}
	end
	
end


return _