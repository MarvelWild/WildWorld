-- global BaseEntity

local _={}

-- todo: check is name used
_.new=function(entity_name,is_service)
	assert(entity_name)
	local result={}
	
	if not is_service then
		result.id=Id.new(entity_name)
	end
	
	result.is_service=is_service
	result.entity_name=entity_name
	result.draw_layer=0
	
	
	return result
end

-- light reference
-- reverse: Db.getByRef
_.getReference=function(entity)
	local result={}
	
	result.id=entity.id
	-- result.login=entity.login no local ent/thin client
	result.entity_name=entity.entity_name
	result.level_name=entity.level_name
	
	return result
end

_.referenceEquals=function(ref1,ref2)
	if ref1.id~=ref2.id then return false end
	
	if ref1.entity_name~=ref2.entity_name then return false end
	
	return true
end




_.draw=function(entity)
	local spriteName=entity.sprite
	if (spriteName==nil) then
		return
	end
	-- todo: cache it, do not query every frame
	local sprite=Img.get(spriteName)
	-- log('drawing:'..Entity.toString(entity))
	love.graphics.draw(sprite,entity.x,entity.y)
end


_.isReferencedBy=function(entity,ref)
	local ref2=_.getReference(entity)
	local result=_.referenceEquals(ref,ref2)
	return result
end
_.refToSting=function(entityRef)
	if entityRef==nil then return "nil" end
	return entityRef.id..":"..entityRef.entity_name
end


_.set_sprite=function(entity,sprite)
	entity.sprite=sprite
	BaseEntity.init_bounds_from_sprite(entity)
end

_.init_bounds_from_sprite=function(entity)
	local spriteName=entity.sprite
	local sprite=Img.get(spriteName)
	local w,h=sprite:getDimensions()
	entity.w=w
	entity.h=h
end

return _