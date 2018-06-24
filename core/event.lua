local _={}

local unprocessed={}

_.new=function()
	local event=BaseEntity.new()
	event.entity="Event"
	event.id=Id.new(event.entity)
	table.insert(unprocessed,event)
	
	return event
end

-- remote/detached
_.register=function(event)
	table.insert(unprocessed,event)
end


local processEvent=function(event)
	if event.isRemote then
		local a=1
	end
	
	
	local eventCode=event.code
	if eventCode=="move" then
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
	elseif eventCode=="use" then
		local entity=Entity.find(event.entity, event.entityId,event.login)
		local entityCode=Entity.get(event.entity)
		if entityCode.use~=nil then
			log("use:"..entity.entity)
			entityCode.use(entity,event.x,event.y)
		else
			log("entity has no 'use' func:"..event.entity)
		end
	elseif eventCode=="transfer_to_server" then
		-- server only event, not processed on client
		-- event чтобы была возможность стакать
		
		if not Session.isClient then
			log("processing transfer_to_server event")
			Entity.acceptAtServer(event.entities)
		end
		
	else
		log("error:event unprocessed:"..pack(event))
	end
end

local sendToServer=function(events)
	local command=
	{
		cmd="events",
		events=events
	}
	Client.send(command)
end




_.update=function()
	local eventsToSend={}
	for k,event in pairs(unprocessed) do
		processEvent(event)
		if not event.isRemote then
			table.insert(eventsToSend,event)
		end
	end
	
	-- WIP: сервер посылает другим клиентам ремот
	
	if Session.isClient then
		if next(eventsToSend)~=nil then
			sendToServer(eventsToSend)
		end
	else 
		if next(unprocessed)~=nil then
			Server.sendEventsToClients(unprocessed)
		end
	end
	
	unprocessed={}
end

return _