-- server

local _={}

-- measured in px/sec
-- todo: use px/frame speed? yes, want precision (meh...). think it later.

-- default to human speed, 5 km/h
-- in game coords: 

local _default_move_speed=15

local calc_distance=Pow.lume.distance

_.calc_move_duration=function(actor,x,y)
	if actor.mounted_on then
		actor=_deref(actor.mounted_on)
	end
	
	local now_x=actor.x+actor.foot_x
	local now_y=actor.y+actor.foot_y
	
	local distance=calc_distance(now_x,now_y,x,y)
	
	local move_speed=actor.move_speed
	if not move_speed then move_speed=_default_move_speed end
	
	local duration=distance/move_speed
	
	-- todo: easy way to log variable with name, some reflection?
	log("calc_move_duration. move_speed:"..move_speed..
		" distance:"..distance..
		" duration:"..duration,
		"move"
		)
	
	return duration
end

return _