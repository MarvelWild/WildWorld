local _={}

local bg=love.graphics.newImage("level/level1/res/bg.jpg")

_.layer=1

_.draw=function()
	love.graphics.draw(bg)
end


return _