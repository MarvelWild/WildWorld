local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Boombox"
	result.x=0
	result.y=0
	Entity.setSprite(result,"boombox")
	result.isDrawable=true
	result.worldId=nil
	--result.aiEnabled=true
	result.canPickup=true
	result.originX=31
	result.originY=25
	
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
_.use=function(boombox,x,y)
	dbgCtxIn("boombox use")
	
	
	log(
		"boombox use. isRegistered:"..tostring(Entity.isRegistered(boombox)).." "..Entity.toString(boombox)
	)

	Entity.usePlaceable(boombox,x,y)

	dbgCtxOut()
end



return _