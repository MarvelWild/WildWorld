local _={}

_.name="Alien"

_.new=function()
	local result=BaseEntity.new()
	
	result.x=0
	result.y=0
	Entity.setSprite(result,"alien")
	result.isDrawable=true
	
	Entity.afterCreated(result,_)
	
	return result
end

_.draw=DrawableBehaviour.draw


return _