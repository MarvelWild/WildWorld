local _={}

local _unprocessed={}

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
	table.insert(_unprocessed,event)
	
	return event
end

-- remote/detached
_.register=function(event)
	table.insert(_unprocessed,event)
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
	if event.code~="move" then
		local a=1
	end
	
	
	local target=event.target
	
	local result=true
	
	-- source==taget
	if event.login==login then 
		result=false
	elseif target=="server" and Session.isServer then 
		result=false 
	elseif target=="self" then 
		result=false 
	elseif target=="login" and event.targetLogin~=login then
		result=false 
	elseif target=="all" and event.login~=Session.login then 
		-- not ours broadcast, should not echo
		result=false 
	end
	
	log("shouldSendEvent:"..Event.toString(event).." to login:"..tostring(login).." result:"..tostring(result))

	return result
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

local cleanEvents=function()
	if #_unprocessed>0 then
		_unprocessed={}
	end
end


local clientUpdate=function()
	local eventsToSend={}
	for k,event in pairs(_unprocessed) do
		processEvent(event)
		if shouldSendEvent(event) then
			table.insert(eventsToSend,event)
		end
	end
	
	if next(eventsToSend)~=nil then
		sendToServer(eventsToSend)
	end
	
	cleanEvents()

end

local serverUpdate=function()
	if next(_unprocessed)~=nil then
		-- server filters events for each client, so unprocessed here
		for k,event in pairs(_unprocessed) do
			processEvent(event)
		end
		
		-- shouldSendEvent проверяется внутри
		Server.sendEventsToClients(_unprocessed)
	end
	
	cleanEvents()
end

	


if Session.isServer then
	_.update=serverUpdate
else -- client
	_.update=clientUpdate
end

_.toString=function(event)
	local result=event.id.." t:"..event.target..' c:'..event.code
	
	return result
end


return _