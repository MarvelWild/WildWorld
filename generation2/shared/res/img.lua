-- Img/.

local Img={}

local baseDir="shared/res/img"

local _newImage=love.graphics.newImage

local i=function(path)
	local fileInfo=love.filesystem.getInfo(path)
	if fileInfo==nil then return nil end
	
	return _newImage(path)
end


Img.get=function(id,ext)
	if not ext then ext="png" end
	local result=rawget(Img,id)
	
	if result==nil then
		result=i(baseDir.."/"..id.."."..ext)
		if result==nil then
			log("error: no img by id:"..id)
		end
		
		Img[id]=result
		
		-- log("image loaded:"..id)
	end
	
	return result
end


local mt={}
local _imgGet=Img.get
mt.__index=function(t,key)
	return _imgGet(key)
end

setmetatable(Img,mt)

return Img