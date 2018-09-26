-- container for worlds

local _={}

local _worlds={}

_.name="Universe"

_.new=function()
	local entity=BaseEntity.new()
	entity.editorVisible=false
	entity.isDrawable=false
	entity.isInWorld=false

	entity.entity="Universe"
	
	BaseEntity.init(entity)
	return entity
end

-- returns world entity
_.newWorld=function(name)
	
	local existing=_worlds[name]
	if existing~=nil then
		log("error:world already exists")
		return existing
	end
	
	local new=World.new()
	_worlds[name]=new
	
	return new
end

_.save=function()
	-- wip
	
	-- prev version: Wo_rld.entities=Entity.getSaving()
	-- new we should save each world
	--[[ wip: reimplement
	
	local str=serialize(W_orld)
	love.filesystem.write(Const.worldSaveFile, str)
	
	
	
	]]--
	
end

_.load=function()
	-- wip
	--[[
		local info=love.filesystem.getInfo(Const.worldSaveFile)
	if info==nil then return false end
	local packed=love.filesystem.read(Const.worldSaveFile)
	W_orld=deserialize(packed)
	assert(W_orld)
	
	if Session.isClient then
		local newEntities={}
		for k,entity in pairs(W_orld.entities) do
			if entity.entity=="Player" or entity.entity=="Seed" then
				table.insert(newEntities,entity)
			end
		end
		
		W_orld.entities=newEntities
	end
	
	Entity.registerWorld()
	]]--
end



return _