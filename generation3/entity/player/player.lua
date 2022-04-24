-- виртуальная сущность - физический игрок. 
-- управляет игровой сущностью - гуманоид, животное,...

local _={}


_.controlled=nil


local image

_.mouse_pressed=function(x,y,button)
	_.x=x
	_.y=y
end


_.load=function()
	image=love.graphics.newImage("entity/player/res/player.png")
end


_.draw=function(entity)
	love.graphics.draw(image,entity.x,entity.y,0,1,1)
end


return _