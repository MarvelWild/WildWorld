local _=function(event)
	
	
	local entity=Entity.findByRef(event.entityRef)
--		if entity==nil then
		
--			local a=1
--			local entity=Entity.find(event.entity, event.entityId,event.login)
--		end
	if entity==nil then
		log("error in event. cannot find entity:"..pack(event))
	end
	
	assert(entity~=nil)
	Entity.smoothMove(entity,event.duration,event.x,event.y)
	
--	Flux.to(entity, event.duration, { x = event.x, y = event.y }):ease("quadout")
--		:onupdate(function()
--					Entity.onMoved(entity)
--				end)
end

return _