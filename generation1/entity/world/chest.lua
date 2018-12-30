local _={}

_.name="Chest"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	-- wip sprite
	Entity.setSprite(result,"chest")
	result.originX=19
	result.originY=19
	
	result.isDrawable=true
	result.worldId=nil
	--result.aiEnabled=true
	result.canPickup=false
	
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

-- place self in world
_.use=function(entity,x,y)
	dbgCtxIn("entity use")
	
	
	log(
		"entity use. isRegistered:"..tostring(Entity.isRegistered(entity)).." "..Entity.toString(entity)
	)

	Entity.usePlaceable(entity,x,y)

	dbgCtxOut()
end

-- todo: open ui



return _