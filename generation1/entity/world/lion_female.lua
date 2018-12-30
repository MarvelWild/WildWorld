local _={}

_.name="LionFemale"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	
	result.mountX=15
	result.mountY=25
	
	result.originX=15
	result.originY=25
	
	result.footX=15
	result.footY=31
	
	Entity.setSprite(result,"lion_female")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/pantera_ai")

return _