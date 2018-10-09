local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Elephant"
	result.x=0
	result.y=0
	
	result.mountX=15
	result.mountY=21
	
	result.originX=15
	result.originY=21	
	
	result.footX=15
	result.footY=31
	
	Entity.setSprite(result,"elephant")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/pantera_ai")

return _