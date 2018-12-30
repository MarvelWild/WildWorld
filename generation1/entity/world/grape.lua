local _={}

_.name="Grape"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	
	result.mountX=12
	result.mountY=5	
	
	result.originX=15
	result.originY=7	
	
	result.footX=15
	result.footY=11
	
	
	Entity.setSprite(result,"grape_a")
	result.isDrawable=true
	result.aiEnabled=Session.isServer
	result.isMountable=false	
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

local _ai=require("misc/ai/pantera_ai")

_.updateAi=_ai


return _