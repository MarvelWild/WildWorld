local _=function(event)
	local entity=Entity.find(event.entity, event.entityId,event.login)
--		if entity==nil then
		
--			local a=1
--			local entity=Entity.find(event.entity, event.entityId,event.login)
--		end
	if entity==nil then
		log("error in event:"..pack(event))
	end
	
	assert(entity~=nil)
	Flux.to(entity, event.duration, { x = event.x, y = event.y }):ease("quadout")
		:onupdate(function()
					Entity.onMoved(entity)
				end)
end

return _