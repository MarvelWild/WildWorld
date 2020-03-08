--[[ 
server

growable duck typing:
planted_on
grow_on
is_growing

grow_phases
{
	duration -- how much frames to grow into next
	sprite -- name of sprite
		todo phase sample here
}

grow_phase_index

use single table for trait, like entity.growable.planted_on?
pro: entities easier to navigate? 
con: performance?
todo: try

]]--

local _={}

-- time to grow (grow_on already checked), do other checks,
-- emit event to actually grow
local start_grow=function(entity)
	log("start_grow")
	
	local event=Event.new("do_grow")
	
	event.entity=_ref(entity)
	event.target="level"
	event.level=entity.level_name
--	assert(event.level~=nil)
	
	
	local current_phase_index=entity.grow_phase_index or 1
	local next_phase=entity.grow_phases[current_phase_index+1]
	if next_phase==nil then
		-- todo: unsubscribe from update_simulation if nothing to sim
		-- log("warn: no next grow phase, don't call start_grow")
		return
	end
	
	event.sprite=next_phase.sprite
	
	if next_phase.duration~=nil then
		entity.grow_on=_frm()+next_phase.duration
	else
		entity.grow_on=nil
	end
	
	Event.process(event)
end

-- tests entity for growable duck typing
_.init=function(entity)
	entity.grow_phase_index=entity.grow_phase_index or 1
	
	local secondsToGrow=love.math.random(30,90)
	
	if Config.fast_grow then
		secondsToGrow=love.math.random(5,8)
	end
	
	local grow_phase=nil
	if entity.grow_phases==nil then
		log("warn: growable entity has no grow_phases")
	else
		grow_phase=entity.grow_phases[entity.grow_phase_index]
	end
	
	-- evo: grow progress, could be altered by weather, watering, fertile land
	
	if grow_phase~=nil then
		entity.grow_on=_frm()+grow_phase.duration
	else
		log("warn: growable has no grow phase")
		entity.grow_on=secondsToGrow*Config.serverFps
	end
end


_.update_simulation=function(entity)
	local frame=Pow.get_frame()
	local grow_on=entity.grow_on
  
	if grow_on~=nil then
		if frame>grow_on then
			start_grow(entity)
		else
			log("not time to grow, now "..frame..", will grow on:"..grow_on, "grow")
		end
	else
		-- evo think moving out of sim / slower sim queue / next update self subscribe at frame we want
		log("wont grow:", "grow")
	end	
end

return _