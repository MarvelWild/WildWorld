local _={}

local unprocessed={}

local _eventHandlers={}
loadScripts("event/",_eventHandlers)

_.new=function()
	-- BaseEntity.new() event is not a entity
	local event={}

	event.entity="Event"
	event.id=Id.new(event.entity)
	event.login=Session.login
	
	-- alias doNotSend
	-- client do not send remote event to server, and should mark received as remote
	event.isRemote=nil
	
	--[[ todo refactor: -isRemote +target
		all			
		self		
		server	
		others	except self
		login		specified login (private chat)
	]]--
	event.target="all"
	event.targetLogin=nil
	event.code=nil
	table.insert(unprocessed,event)
	
	return event
end

-- remote/detached
_.register=function(event)
	table.insert(unprocessed,event)
end

-- skip means 'do not process locally'
local shouldSkipEvent=function(event)
	assert(event.target)
	
	if event.target=="server" then
		if Session.isClient then
			return true 
		end
	elseif event.target=="self" then
		if event.login~=Session.login then
			return true 
		end
	end
	
	return false
end


local processEvent=function(event)
	if shouldSkipEvent(event) then 
		log("skip event:"..Event.toString(event))
		return
	end
	
	local eventCode=event.code
	
	local handler=_eventHandlers[eventCode]
	if handler~=nil then
		log("processing event:".._.toString(event).." full:"..pack(event))
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


-- think both server and client
-- login is recipient login, nil means broadcast (for server) or 
local shouldSendEvent=function(event,login)
	local target=event.target
	
	-- source==taget
	if event.login==login then return false end
	
	if target=="server" and Session.isServer then return false end
	
	if target=="self" then return false end

	if target=="login" and event.targetLogin~=login then return false end
	
	-- not ours broadcast, should not echo
	if target=="all" and event.login~=Session.login then return false end

	return true
end

local prepareEventsForLogin=function(login,events)
	local result={}
	
	for k,event in pairs(events) do
		if shouldSendEvent(event,login) then
			table.insert(result,event)
		end
	end
	
	return result
end

_.prepareEventsForLogin=prepareEventsForLogin


_.update=function()

	local eventsToSend={}
	for k,event in pairs(unprocessed) do
		processEvent(event)
		if shouldSendEvent(event) then
			table.insert(eventsToSend,event)
		end
	end
	
	if Session.isClient then
		if next(eventsToSend)~=nil then
			sendToServer(eventsToSend)
		end
	else -- server
		if next(unprocessed)~=nil then
			-- server filters events for each client, so unprocessed here
			Server.sendEventsToClients(unprocessed)
		end
	end
	
	unprocessed={}
end

_.toString=function(event)
	local result=event.id.." t:"..event.target..' c:'..event.code
	
	return result
end


return _