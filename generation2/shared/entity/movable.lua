local _={}



local smoothMove=function(actor,durationSec,x,y)
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

-- only moves locally, no event
_.move=function(actor,x,y)
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