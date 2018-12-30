local _={}

_.name="HorseSmall2"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	Entity.setSprite(result,"horse_small_2")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw
_.updateAi=require("misc/ai/sheep_ai")

return _