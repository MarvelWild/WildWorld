-- container for worlds

local _={}

_.name="Universe"

_.new=function(options)
	local entity=BaseEntity.new()
	entity.editorVisible=false
	entity.isDrawable=false
	entity.worldId=nil
	entity.worlds={}

	Entity.afterCreated(entity,_,options)
	return entity
end

-- returns world entity
-- name is internal short name
_.newWorld=function(name)
	assert(name)
	local universe=CurrentUniverse
	
	local existing=universe.worlds[name]
	if existing~=nil then
		log("error:world already exists")
		return existing
	end
	
	local new=World.new()
	new.worldName=name
	universe.worlds[name]=new
	
	return new
end

_.getWorld=function(name)
	return CurrentUniverse.worlds[name]
end

 
_.save=function()
	local universe=CurrentUniverse
	local str=serialize(universe)
	love.filesystem.write(Const.universeSaveFile, str)
	
	log("universe saved")
end

_.load=function()
	if Session.isServer then
		local saveFile=Const.universeSaveFile
		local fs=love.filesystem
		
		local info=fs.getInfo(saveFile)
		
		if info==nil then return false end
		
		local packed=fs.read(saveFile)
		CurrentUniverse=deserialize(packed)
		assert(CurrentUniverse)
	else
		-- client wont load universe from file
		return false
	end
	
	return true
end



return _