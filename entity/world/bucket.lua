local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Bucket"
	result.x=0
	result.y=0
	Entity.setSprite(result,"bucket_empty")
	result.isDrawable=true
	result.isInWorld=false
	--result.aiEnabled=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=function(entity)
	if not entity.isInWorld then return end
	
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end

-- place self in world
_.use=function(bucket,x,y)
	-- todo: destroy on stack end
	bucket.x=x
	bucket.y=y
	
	Player.removeItem(bucket)
	
	Entity.transferToServer({bucket})
	bucket.isInWorld=true
end



return _