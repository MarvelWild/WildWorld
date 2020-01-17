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


local smoothMove=function(actor,durationSec,x,y)
	local onComplete=function(p1,p2) 
		_smooth_moving[actor]=nil
	end

	local existing_tween=_smooth_moving[actor]
	if existing_tween~=nil then
		existing_tween:stop()
	end
	
	local onUpdate=function()
		CollisionService.onEntityMoved(actor)
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


-- only moves locally, no event
_.move=function(actor,x,y)
	if actor==nil then
		local a=1
	end
	
	-- по этому флагу entity определит destroy
	-- можно сделать в init, понятней будет
	actor.is_movable=true
	
	local finalX
	local finalY

	
	
	if actor.footX~=nil then
		finalX=x-actor.footX
		finalY=y-actor.footY
	else
		finalX=x
		finalY=y
	end
	
	smoothMove(actor,2,finalX,finalY)
end

return _