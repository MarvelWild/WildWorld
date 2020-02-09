--[[ 
growable duck typing:
planted_on
grow_on
is_growing

use single table for trait, like entity.growable.planted_on?
pro: entities easier to navigate? 
con: performance?
todo: try

]]--

local _={}

-- time to grow, do checks,
-- emit event to actually grow
local start_grow=function(entity)
	-- wip data
	-- wip remote
	log("start_grow")
	
	-- wip emit grow event to all on level
	local event=Event.new("do_grow")
	
	event.entity=_ref(entity)
	event.target="level"
	event.level=entity.levelName
	
	
	Event.process(event)
	-- wip handle on server
	-- wip handle on client
	
end

_.init=function(entity)
	local secondsToGrow=love.math.random(30,90)
	
	if Config.fast_grow then
		secondsToGrow=love.math.random(5,8)
	end
	
	-- evo: grow progress, could be altered by weather, watering, fertile land
	entity.grow_on=secondsToGrow*Config.serverFps
end


_.update_simulation=function(entity)
	local frame=Pow.get_frame()
	local grow_on=entity.grow_on
  
	if grow_on~=nil then
		if frame>grow_on then
			start_grow(entity)
		else
			log("not time to grow, now "..frame..", will grow on:"..grow_on)
		end
	else
		-- evo think moving out of sim / slower sim queue / next update self subscribe at frame we want
		log("wont grow:")
	end	
end

return _