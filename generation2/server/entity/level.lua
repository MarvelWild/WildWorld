-- server level entity

local _={}


local _activeLevels={}
local _descriptors={}

_.entity_name=Pow.currentFile()

--_.new=function()
--	local result={}
--	result.sizeX=4096
--	result.sizeY=4096
	
--	return result
--end

_.isActive=function(level_name)
	return _activeLevels[level_name]
end

_.getDescriptor=function(level_name)
	local existing=_descriptors[level_name]
	if existing~=nil then
		return existing
	else
		local fileName="level/"..level_name
		local newDescriptor=require(fileName)
		if newDescriptor==nil then
			log("error:no level descriptor:"..level_name)
		end
		
		return newDescriptor
	end
end

_.new=function()
	local result={}
	
	return result
end



-- activate entire level: all entities on it
_.activate=function(level_name)
	log("level activate:"..level_name, "verbose")
	
	if _activeLevels[level_name] then return end
	
	local entityContainers=Db.getLevelContainer(level_name)
	for k,entityContainer in pairs(entityContainers) do
		for k2,entity in pairs(entityContainer) do
			Entity.add(entity)
		end
		
	end
	
	_activeLevels[level_name]=true
end






return _