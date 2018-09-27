-- global Tile
local _={}

local _levelsDir="res/img/level/"

local _baseDir=_levelsDir.."main/"

local _container={}

-- get image by path
local i=function(path)
	local fileInfo=love.filesystem.getInfo(path)
	if fileInfo==nil then return nil end
	
	return LG.newImage(path)
end


_.setLevel=function(name)
	_baseDir=_levelsDir..name.."/"
	_container={}
end


_.get=function(id)
	
	local result=_container[id]
	
	if result==nil then
		result=i(_baseDir..id..".png")
		if result==nil then
			log("error: no img by id:"..id)
		end
		
		_container[id]=result
		
		--log("tile loaded:"..id)
	end
	
	return result
end

return _
