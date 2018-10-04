local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Cauldron"
	result.x=0
	result.y=0
	Entity.setSprite(result,"cauldron")
	result.isDrawable=true
	result.worldId=nil
	--result.aiEnabled=true
	result.canPickup=true
	result.originX=8
	result.originY=10
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=function(entity)
	--todo: remove from drawables on removing from world
	if entity.worldId==nil then return end
	
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end

-- place self in world
_.use=function(cauldron,x,y)
	dbgCtxIn("cauldron use")
	
	
	log(
		"cauldron use. isRegistered:"..tostring(Entity.isRegistered(cauldron)).." "..Entity.toString(cauldron)
	)

	Entity.usePlaceable(cauldron,x,y)

	dbgCtxOut()
end



return _