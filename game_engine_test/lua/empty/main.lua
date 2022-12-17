local entities={}
local sprite=nil

local rnd_x=function()
	return math.random(1,800)
end


local make_entity=function()
	local entity={}
	
	entity.x=
	
	table.insert(entities,entity)
end



love.load=function()
end


love.update=function()
end


love.draw=function()
	local fps = love.timer.getFPS( )
	love.graphics.print("fps:"..fps)
	--love.graphics.print("count:"..#entities)
end
