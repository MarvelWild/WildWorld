-- server level entity

local _={}


-- k - name, v - level
local _activeLevels={}

_.entity_name=Pow.currentFile()

--_.new=function()
--	local result={}
--	result.sizeX=4096
--	result.sizeY=4096
	
--	return result
--end

_.isActive=function(level_name)
	return _activeLevels[level_name]~=nil
end


-- gets/creates active level
_.get_level=function(level_name)
	local existing=_activeLevels[level_name]
	if existing~=nil then
		return existing
	else
		local db_level=Db.get_level(level_name)
		if db_level then
			-- todo: this level does not contains functions, init(). now ok
			
			return db_level
		end
		
		local fileName="level/"..level_name
		local new_level=require(fileName)
		if new_level==nil then
			log("error:no level descriptor:"..level_name)
		end
		
		if new_level.init then
			new_level.init()
		end
		
		Db.set_level(level_name,new_level)
		
		return new_level
	end
end

_.new=function()
	local result={}
	
	return result
end



-- activate entire level: all entities on it
_.activate=function(level_name)
	log("level activate:"..level_name, "verbose")
	
	local level=_.get_level(level_name)
	
	if _activeLevels[level_name] then return end
	
	local entityContainers=Db.getLevelContainer(level_name)
	for k,entityContainer in pairs(entityContainers) do
		for k2,entity in pairs(entityContainer) do
			Entity.add(entity)
		end
		
	end
	
	_activeLevels[level_name]=level
end






return _