-- \shared\entity\trait\movable

local _={}


-- to destroy tweens when entity destroys
local _smooth_moving={}

local stop_tween=function(entity)
	local existing_tween=_smooth_moving[entity]
	if existing_tween~=nil then
		existing_tween:stop()
		_smooth_moving[entity]=nil
	end
end

-- вызывается на каждом движении - каждый кадр при плавном движении.
-- обновляются коллизии, связанные
local on_moved=function(moved_entity)
	CollisionService.onEntityMoved(moved_entity)
	
	local mount_slots=moved_entity.mount_slots
	if mount_slots~=nil then
		for k,slot in pairs(mount_slots) do
			local rider_ref=slot.rider
			if rider_ref~=nil then
				local rider=_deref(rider_ref)
				
				if rider then
					-- todo: если райдер в процессе посадки - плавно двигать
					local riderX,riderY=Mountable.get_rider_point(moved_entity,rider,slot)
					_.instant_move(rider,riderX,riderY)
				else
					log("warn:no rider to follow mount")
				end
			end
		end
	end
end

_.instant_move=function(entity,new_x,new_y)
	-- face direction
	entity.is_watching_left=new_x<entity.x
	
	entity.x=new_x
	entity.y=new_y
	
	-- update rider collision
	on_moved(entity)
end


local smoothMove=function(actor,durationSec,x,y,on_complete)
	log("smoothMove:".._ets(actor).." to".._xy(x,y).." dur:"..durationSec, "move")
	
	Animation_service.set_state(actor,"walk")
	
	local onComplete=function(p1,p2) 
		_smooth_moving[actor]=nil
		
		Animation_service.set_state(actor,"idle")
		if on_complete then 
			on_complete(actor)
		end
	end

	local existing_tween=_smooth_moving[actor]
	if existing_tween~=nil then
		existing_tween:stop()
	end
	
	local onUpdate=function()
		on_moved(actor)
	end
	
	
	-- todo: i want inertia at beginning and end of move, not for entire duration
	
	
	local tween=Flux.to(actor, durationSec, { x=x, y=y })
		-- :ease("quadout")
--		:ease("linear") -- for debug
--		:ease("quadout_edge")
-- todo: make out time in frames, not relative
		:ease("quadout")
		:onupdate(onUpdate)
		:oncomplete(onComplete)
		
	_smooth_moving[actor]=tween
end

_.smooth_move=smoothMove




-- вызывается по флагу is_movable
_.destroy=function(entity)
	stop_tween(entity)
end




-- shared. only moves locally, no event
-- todo: refactor params to table
-- force_this: resolve mount or not
_.move=function(actor,x,y,duration,force_this,ignore_foot)
	log("Movable.move:".._ets(actor).." to:".._xy(x,y).." dur:"..duration, "move")
	
	if not force_this then
		if actor.mounted_on~=nil then
			local final_actor=_deref(actor.mounted_on)
			actor=final_actor
		end
	end

	-- todo: test updated entity
	-- по этому флагу entity определит destroy to stop tweens
	actor.is_movable=true
	
	local finalX
	local finalY

	if not ignore_foot then
		if actor.foot_x~=nil then
			finalX=x-actor.foot_x
			finalY=y-actor.foot_y
		else
			log("warn: movable has no foot_x:".._ets(actor))
			finalX=x
			finalY=y
		end
	else
		finalX=x
		finalY=y
	end
	
	-- face direction
	actor.is_watching_left=finalX<actor.x
	
	local entity_code=Entity.get_code(actor)
	local on_complete=entity_code.on_move_complete
	smoothMove(actor,duration,finalX,finalY,on_complete)
end


_.is_moving=function(actor)
	return _smooth_moving[actor]~=nil
end

_.cannot_move=function(actor)
	local is_mounting=Mountable.is_mounting(actor)
	return is_mounting
end


return _