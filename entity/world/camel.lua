local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Camel"
	result.x=0
	result.y=0
	
	result.mountX=29
	result.mountY=44
	
	result.originX=29
	result.originY=44	
	
	result.footX=31
	result.footY=62
	
	Entity.setSprite(result,"camel")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/sheep_ai")

return _