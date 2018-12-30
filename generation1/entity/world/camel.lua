local _={}

_.name="Camel"

_.new=function(options)
	local result=BaseAnimal.new(options)
	
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
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.slowUpdate=BaseAnimal.slowUpdate
_.draw=DrawableBehaviour.draw

_.updateAi=require("misc/ai/sheep_ai")

return _