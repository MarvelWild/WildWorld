local _={}

_.name="Sheep"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	Entity.setSprite(result,"sheep2")
	result.isDrawable=true
	result.aiEnabled=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=function(sheep)
	local sprite=Img[sheep.spriteName]
	LG.draw(sprite,sheep.x,sheep.y)
end


-- managed by Entity
_.updateAi=require("misc/ai/sheep_ai")


return _