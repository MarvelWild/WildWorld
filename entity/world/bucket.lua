local _={}

_.name="Bucket"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	Entity.setSprite(result,"bucket_empty")
	result.isDrawable=true
	result.worldId=nil
	--result.aiEnabled=true
	result.canPickup=true
	result.originX=8
	result.originY=8
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=function(entity)
	if entity.worldId==nil then return end
	
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end

-- place self in world
_.use=function(bucket,x,y)
	-- todo: destroy on stack end
	
	Entity.usePlaceable(bucket,x,y)
end



return _