local _={}

_.name="Tiger"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	
	result.mountX=13
	result.mountY=22
	
	result.originX=13
	result.originY=22
	
	result.footX=13
	result.footY=31
	
	Entity.setSprite(result,"tiger")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/pantera_ai")

return _