local _={}

_.new=function()
	local result={}
	
	result.id=Id.new("alien")
	result.entity="Alien"
	result.x=0
	result.y=0
	result.spriteName="alien"
	result.isDrawable=true
	
	Entity.register(result)
	
	return result
end

_.draw=function(pantera)
	local sprite=Img[pantera.spriteName]
	LG.draw(sprite,pantera.x,pantera.y)
end


return _