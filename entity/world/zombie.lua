local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Zombie"
	result.x=0
	result.y=0
	
	result.originX=3
	result.originY=7
	
	Entity.setSprite(result,"zombie_1")
	result.isDrawable=true
	result.aiEnabled=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=function(entity)
	local sprite=Img[entity.spriteName]
	LG.draw(sprite,entity.x,entity.y)
end


_.updateAi=require("misc/ai/zombie_ai")


return _