local _={}

local _lastIdByName={}

local savePath
local _pow

local _serialize
local _deserialize

_.init=function(pow)
	_pow=pow
	--todo save dir
	local saveDir=nil
	if saveDir==nil then saveDir="" end
	
	savePath=saveDir.."id"
	
	_serialize=pow.serialize
	_deserialize=pow.deserialize
	
	_.load()
end


_.new=function(name)
	local prevId=_lastIdByName[name]
	if prevId==nil then prevId=0 end
	local result=prevId+1
	
	_lastIdByName[name]=result
	
	return result
end


_.save=function()
	local serialized=_serialize(_lastIdByName)
	love.filesystem.write(savePath, serialized)
	
end

_.load=function()
	--	if _lastIdByName~=nil then log("warn:id alrea") its ok
	local serialized=love.filesystem.read(savePath)
	
	if serialized~=nil then
		_lastIdByName=_deserialize(serialized)
	else
		_lastIdByName={}
	end
	
end


return _