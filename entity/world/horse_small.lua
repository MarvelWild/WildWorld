local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="HorseSmall"
	result.x=0
	result.y=0
	result.mountX=7
	result.mountY=17
	Entity.setSprite(result,"horse_small")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/sheep_ai")

return _