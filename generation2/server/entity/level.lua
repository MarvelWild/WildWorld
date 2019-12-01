-- server level entity

local _={}


local _activeLevels={}

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

_.load_all_metadata=function()
	-- wip load levels metadata
	-- wip call this
end




return _