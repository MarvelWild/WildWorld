local _={}

local _unprocessed={}

local _eventHandlers={}
loadScripts("event/",_eventHandlers)

_.new=function()
	-- BaseEntity.new() event is not a entity
	--log("Event.new:".._traceback())
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
	local target=event.target
	assert(target)
	
	if target=="server" then
		if Session.isClient then
			return true 
		end
	elseif target=="self" then
		if event.login~=Session.login then
			return true 
		end
	elseif target=="others" then
		if event.login==Session.login then
			return true 
		end		
	end
	
	return false
end

local doProcessEvent=function(event)
	local eventCode=event.code
	
	local handler=_eventHandlers[eventCode]
	if handler~=nil then
		log("processing event:".._.toString(event).." full:"..pack(event))
		handler(event)
	else
		log("error:event unprocessed:"..pack(event))
	end
end




local processEvent=function(event)
	if shouldSkipEvent(event) then 
		log("skip event:"..Event.toString(event))
		return
	end
	
	doProcessEvent(event)
end

-- without queue, without checks
_.doProcessEvent=function(event)
	log("doProcessEvent:"..Event.toString(event))
	doProcessEvent(event)
end


local sendToServer=function(events)
	local command=
	{
		cmd="events",
		events=events
	}
	Client.send(command)
end



local shouldSendEventFromClient=function(event,targetLogin)
	
	local target=event.target
	local eventLogin=event.login
	local ourLogin=Session.login
	
	-- на клиенте события можно отправлять только серверу
	local result=true
	
	-- source==taget
	if eventLogin==targetLogin then -- себе в любом случае не нужно слать, у нас оно уже есть
		result=false
	elseif eventLogin~=ourLogin then -- чужие не реброадкастим
		result=false
	elseif target=="self" then 
		result=false 
	elseif target=="server" then 
		result=true 
	elseif target=="others" then 
		result=true 
	elseif target=="all" then 
		result=true
	elseif target=="login" then -- подразумеваем что используется только другой логин (пока что)
		result=true
	else
		log("error:unk event:"..Event.toString(event))
	end
	
	log("shouldSendEventFromClient:"..Event.toString(event).." targetLogin:"..tostring(targetLogin).." result:"..tostring(result))

	return result
end


-- login is recipient login, nil means broadcast (for server)
local shouldSendEventFromServer=function(event,targetLogin)
	local target=event.target
	
	local result=true
	local ourLogin=Session.login
	local sourceLogin=event.login
	
	-- source==taget
	if sourceLogin==targetLogin then -- не нужно возвращать отправителю
		result=false
	elseif targetLogin==ourLogin then -- не нужно слать себе
		result=false 
	elseif target=="others" then 
		-- result=true
	elseif target=="server" then 
		-- эти только принимаем
		result=false 
	elseif target=="self" then 
		result=false 
	elseif target=="login" then
		if event.targetLogin~=targetLogin then
			result=false
		-- else result=true
		end
	elseif target=="all" then 
		-- result=true
	else
		log("error:unk event:"..Event.toString(event))
	end
	
	log("shouldSendEventFromServer:"..Event.toString(event).." to login:"..tostring(targetLogin).." result:"..tostring(result))

	return result	
end


local shouldSendEvent
if Session.isServer then
	shouldSendEvent=shouldSendEventFromServer
else
	shouldSendEvent=shouldSendEventFromClient
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