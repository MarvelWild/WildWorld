-- global DrawableBehaviour
local _={}

_.name="DrawableBehaviour"

_.setup=function(entity)
end


local _draw=LG.draw

-- todo: origin point
local _drawFlipped=function(drawable,x,y)
	_draw(drawable,x,y,0,-1,1)
end




_.draw=function(entity)
	local spriteName=entity.spriteName
	if spriteName==nil then return end
	local sprite=Img[entity.spriteName]
	_draw(sprite,entity.x,entity.y)
	-- _drawFlipped(sprite,entity.x,entity.y)
	

--	local entityLocals=Entity.getLocals(entity)
--	if entityLocals.isMoving then
--		LG.print("moving",entity.x,entity.y)
--	end
end


return _