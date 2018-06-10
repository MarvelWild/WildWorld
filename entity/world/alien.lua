local _={}

_.new=function()
	local result=BaseEntity.new()
	
	result.id=Id.new("alien")
	result.entity="Alien"
	result.x=0
	result.y=0
	result.spriteName="alien"
	result.isDrawable=true
	
	BaseEntity.init(result,nil)
	
	return result
end

_.draw=function(pantera)
	local sprite=Img[pantera.spriteName]
	LG.draw(sprite,pantera.x,pantera.y)
end


return _