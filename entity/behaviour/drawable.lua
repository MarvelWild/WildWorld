-- global DrawableBehaviour
local _={}

_.setup=function(entity)
end


local _draw=LG.draw
_.draw=function(entity)
	local sprite=Img[entity.spriteName]
	_draw(sprite,entity.x,entity.y)
	
--	local entityLocals=Entity.getLocals(entity)
--	if entityLocals.isMoving then
--		LG.print("moving",entity.x,entity.y)
--	end
end


return _