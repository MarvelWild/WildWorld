local _={}

local baseDir="res/img/level_main/"

local i=function(path)
	local fileInfo=love.filesystem.getInfo(path)
	if fileInfo==nil then return nil end
	
	return LG.newImage(path)
end


_.get=function(id)
	
	local result=rawget(_,id)
	
	if result==nil then
		result=i(baseDir..id..".png")
		if result==nil then
			log("error: no img by id:"..id)
		end
		
		_[id]=result
		
		--log("tile loaded:"..id)
	end
	
	return result
end


local mt={}
mt.__index=function(t,key)
	return t.get(key)
end

setmetatable(_,mt)

return _




--local _={}

--local loadTiles=function()
--	local dir="res/img/level_main/"
--	local dirItems=love.filesystem.getDirectoryItems(dir)
--	for k,file in ipairs(dirItems) do
--		if Allen.endsWith(file, ".png") then
--				local pos=string.find(file,".png")
--				local key=tonumber(string.sub(file,0,pos-1))
				
--				_[key]=LG.newImage(dir..file)
----				log("tile loaded:"..file)
--		end
--	end
	
--	-- tile 0 based, but table is 1 based, -1 is ok
--	log("total tiles:"..#_)
	
--end

--loadTiles()

--local mt={}
--mt.__index=function(t,key)
--	return t.get(key)
--end

--setmetatable(Img,mt)

--return _