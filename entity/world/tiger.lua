local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.entity="Tiger"
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
	
	BaseEntity.init(result,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/pantera_ai")

return _