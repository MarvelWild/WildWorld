local _={}

_.name="Alien"

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.x=0
	result.y=0
	Entity.setSprite(result,"alien")
	result.isDrawable=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

_.draw=DrawableBehaviour.draw


return _