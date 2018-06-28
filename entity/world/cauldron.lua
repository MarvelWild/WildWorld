local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Cauldron"
	result.x=0
	result.y=0
	Entity.setSprite(result,"cauldron")
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
_.use=function(cauldron,x,y)
	-- todo: destroy on stack end
	

	cauldron.x=x
	cauldron.y=y

	Player.removeItem(cauldron)
	
	Entity.transferToServer({cauldron})
	Entity.placeInWorld(cauldron)
end



return _