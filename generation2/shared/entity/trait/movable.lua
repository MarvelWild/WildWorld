-- shared movable

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

local on_moved=function(moved_entity)
	CollisionService.onEntityMoved(moved_entity)
	
	
	if moved_entity.mounted_by~=nil then
		local rider=_deref(moved_entity.mounted_by)
		
		-- rider could log off, should handle on delete
		if rider~=nil then
			local riderX,riderY=Mountable.get_rider_point(moved_entity,rider)
		
			_.instant_move(rider,riderX,riderY)
		end
	end
end

_.instant_move=function(entity,new_x,new_y)
	entity.x=new_x
	entity.y=new_y
	
	-- update rider collision
	on_moved(entity)
end


local smoothMove=function(actor,durationSec,x,y)
	log("smoothMove:".._ets(actor).." to"..x..","..y, "move")
	
	if actor.entity_name=="pegasus" then
		local a=1
	end
	
	
	local onComplete=function(p1,p2) 
		_smooth_moving[actor]=nil
	end

	-- todo: actor может обновиться, это dto. рассмотреть этот случай/написать тест.
	local existing_tween=_smooth_moving[actor]
	if existing_tween~=nil then
		existing_tween:stop()
	end
	
	local onUpdate=function()
		on_moved(actor)
	end
	
	local tween=Flux.to(actor, durationSec, { x=x, y=y }):ease("quadout")
		:onupdate(onUpdate)
		:oncomplete(onComplete)
		
	_smooth_moving[actor]=tween
end





-- вызывается по флагу is_movable
_.destroy=function(entity)
	stop_tween(entity)
end


-- todo: speed/time
-- only moves locally, no event
-- todo: refactor params to table
_.move=function(actor,x,y,force_this,ignore_foot)
	log("Movable.move:".._ets(actor).." to:"..x..","..y)
--	if actor==nil then
--		local a=1
--	end
	
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
		if actor.footX~=nil then
			finalX=x-actor.footX
			finalY=y-actor.footY
		else
			log("warn: movable has no footX:".._ets(actor))
			finalX=x
			finalY=y
		end
	else
		finalX=x
		finalY=y
	end
	
	
	
	
	smoothMove(actor,2,finalX,finalY)
end


_.is_moving=function(actor)
	return _smooth_moving[actor]~=nil
end

_.cannot_move=function(actor)
	local is_mounting=Mountable.is_mounting(actor)
	return is_mounting
end


return _