-- global DrawableBehaviour
local _={}

_.setup=function(entity)
end


local _draw=LG.draw
_.draw=function(entity)
	local sprite=Img[entity.spriteName]
	_draw(sprite,entity.x,entity.y)
end


return _