-- server level entity

local _={}


local _activeLevels={}
local _descriptors={}

_.entityName=Pow.currentFile()

--_.new=function()
--	local result={}
--	result.sizeX=4096
--	result.sizeY=4096
	
--	return result
--end

_.isActive=function(levelName)
	return _activeLevels[levelName]
end

_.getDescriptor=function(levelName)
	local existing=_descriptors[levelName]
	if existing~=nil then
		return existing
	else
		local fileName="level/"..levelName
		local newDescriptor=require(fileName)
		if newDescriptor==nil then
			log("error:no level descriptor:"..levelName)
		end
		
		return newDescriptor
	end
end

_.new=function()
	local result={}
	
	return result
end



-- activate entire level: all entities on it
_.activate=function(levelName)
	if _activeLevels[levelName] then return end
	
	local entityContainers=Db.getLevelContainer(levelName)
	for k,entityContainer in pairs(entityContainers) do
		for k2,entity in pairs(entityContainer) do
			Entity.add(entity)
		end
		
	end
	
	_activeLevels[levelName]=true
end






return _