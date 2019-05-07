local _={}

_.move=function(actor,x,y)
	-- wip smooth
	-- actor.x=x
	-- actor.y=y
	_.smoothMove(actor,2,x,y)
end

_.smoothMove=function(actor,durationSec,x,y)
--	local entityLocals=Entity.getLocals(entity)
--	entityLocals.isMoving=true
	
--	local prevTween=entityLocals.moveTween
--	if prevTween~=nil then
--		log("cancel prev move")
--		prevTween:stop()
--	end
	
--	local onComplete=function() 
--		entityLocals.isMoving=false
--		entityLocals.moveTween=nil
--		log("end move:".._ets(entity))
--	end
	
	local onUpdate=function()
		-- Entity.onMoved(entity)
	end
	
	
	local tween=Flux.to(actor, durationSec, { x=x, y=y }):ease("quadout")
		:onupdate(onUpdate)
--		:oncomplete(onComplete)
		
--	entityLocals.moveTween=tween
end


return _