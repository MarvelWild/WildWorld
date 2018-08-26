local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="HorseSmall"
	result.x=0
	result.y=0
	Entity.setSprite(result,"horse_small")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

-- wip: disabled for mount test
-- _.updateAi=require("misc/ai/sheep_ai")

return _