local _={}

_.x=0
_.y=0

_.layer=2

local image

_.load=function()
	image=love.graphics.newImage("entity/player/res/player.png")
end


_.draw=function(entity)
	love.graphics.draw(image,entity.x,entity.y,0,1,1)
end


return _