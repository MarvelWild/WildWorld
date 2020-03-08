-- server

local _={}

-- measured in ... (px/sec | px/frame)
local _default_move_speed=2

local calc_distance=Pow.lume.distance

_.calc_move_duration=function(actor,x,y)
	
	local now_x=actor.x
	local now_y=actor.y
	
	local distance=calc_distance(now_x,now_y,x,y)
	
	local move_speed=actor.move_speed
	
	-- wip
	return 14
end

return _