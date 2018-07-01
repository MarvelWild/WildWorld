local _={}

local unprocessed={}

local _eventHandlers={}
loadScripts("event/",_eventHandlers)

_.new=function()
	local event=BaseEntity.new()
	event.entity="Event"
	event.id=Id.new(event.entity)
	
	-- alias doNotSend
	-- client do not send remote event to server, and should mark received as remote
	event.isRemote=nil
	
	event.isServerOnly=nil
	event.code=nil
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
	
	if Session.isClient and event.isServerOnly then
		-- its ok (pickup)
		--log("error: try to process server event on client")
		return
	end
	
	
	local eventCode=event.code
	
	local handler=_eventHandlers[eventCode]
	if handler~=nil then
		handler(event)
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

	-- todo: split server/client
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