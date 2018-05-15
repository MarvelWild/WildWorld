local _={}

local unprocessed={}

_.new=function(event)
	event.id=Id.new("event")
	unprocessed[event.id]=event
	
	return event
end

local processEvent=function(event)
	if event.code=="move" then
		local entity=Entity.find(event.entity, event.entityId)
		Flux.to(entity, event.duration, { x = event.x, y = event.y }):ease("quadout")
	else
		log("error:event unprocessed:"..pack(event))
	end
end



_.update=function()
	for k,event in pairs(unprocessed) do
		processEvent(event)
	end
	
	unprocessed={}
end

return _