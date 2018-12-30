local _={}

_.name="SnakeMature"
_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	

	
result.originX=20
result.originY=60

result.mountX=result.originX
result.mountY=result.originY
	
--	result.footX=30
--	result.footY=63
	
	Entity.setSprite(result,"snake-mature")
	result.isDrawable=true
	result.aiEnabled=true
	result.isMountable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/pantera_ai")

return _