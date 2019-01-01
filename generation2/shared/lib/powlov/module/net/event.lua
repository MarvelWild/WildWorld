-- connected to pow.net.event

local _={}

local _unprocessed={}

_.unprocessed=_unprocessed

local _eventHandlers={}

local _pow
local _id
local _netState
local _serialize
local _deserialize

---- login is recipient login, nil means broadcast (for server)
--local shouldSendEventFromServer=function(event,targetLogin)
--	local target=event.target
	
--	local result=true
--	local ourLogin=_netState.login
--	local sourceLogin=event.login
	
--	-- source==taget
--	if sourceLogin==targetLogin then -- не нужно возвращать отправителю
--		result=false
--	elseif targetLogin==ourLogin then -- не нужно слать себе
--		result=false 
--	elseif target=="others" then 
--		-- result=true
--	elseif target=="server" then 
--		-- эти только принимаем
--		result=false 
--	elseif target=="self" then 
--		result=false 
--	elseif target=="login" then
--		if event.targetLogin~=targetLogin then
--			result=false
--		-- else result=true
--		end
--	elseif target=="all" then 
--		-- result=true
--	else
--		log("error:unk event:".._.toString(event))
--	end
	
--	log("shouldSendEventFromServer:".._.toString(event).." to login:"..tostring(targetLogin).." result:"..tostring(result))

--	return result	
--end






_.toString=function(event)
	local result=event.id.." t:"..event.target..' c:'..event.code
	
	return result
end


-- remote/detached
_.register=function(event)
	log("register event:".._.toString(event))
	table.insert(_unprocessed,event)
end

_.new=function(code)
	-- BaseEntity.new() event is not a entity
	--log("Event.new:".._traceback())
	local event={}
	
	event.entity="Event"
	event.id=_id.new(event.entity)
	event.login=_netState.login
	
	-- alias doNotSend
	-- client do not send remote event to server, and should mark received as remote
	event.isRemote=nil
	
	--[[
		all			
		self		
		server	
		others	except self
		login		specified login (private chat)
	]]--
	event.target="all"
	event.targetLogin=nil
	
	-- по коду определяем обработчик
	event.code=code
	
	_.register(event)
	
	return event
end



-- skip means 'do not process locally'
local shouldSkipEvent=function(event)
	local target=event.target
	assert(target)
	
	local login=_netState.login
	if target=="server" then
		if _netState.isClient then
			return true 
		end
	elseif target=="self" then
		if event.login~=login then
			return true 
		end
	elseif target=="others" then
		if event.login==login then
			return true 
		end		
	end
	
	return false
end




-- move processing logic outside? no, connect handlers to this module
local doProcessEvent=function(event)
	local eventCode=event.code
	
	local handler=_eventHandlers[eventCode]
	if handler~=nil then
		log("processing event:".._.toString(event).." full:".._serialize(event))
		handler(event)
	else
		-- should be registered in _eventHandlers by creating
		-- event/name.lua. autoloaded from there
		log("error:event unprocessed:".._serialize(event))
	end
end




local processEvent=function(event)
	if shouldSkipEvent(event) then 
		log("skip event:".._.toString(event))
		return
	end
	
	doProcessEvent(event)
end



_.update=function()
	for k,event in pairs(_unprocessed) do
		processEvent(event)
	end
end

-- without queue, without checks
_.doProcessEvent=function(event)
	log("doProcessEvent:".._.toString(event))
	doProcessEvent(event)
end










-- wip: let server/client do this
-- todo: doc
--local prepareEventsForLogin=function(login,events)
--	local result={}
	
--	for k,event in pairs(events) do
--		if _shouldSendEvent(event,login) then
--			table.insert(result,event)
--		end
--	end
	
--	return result
--end

--_.prepareEventsForLogin=prepareEventsForLogin

_.cleanEvents=function()
	--todo: test all events processed
	
	table.clear(_unprocessed)
	
	-- referenced fron otheer places, cannot make new
--	if #_unprocessed>0 then
--		_unprocessed={}
--	end
end

-- идея: подключать сюда функцию сенда.

-- wip: move to client
--local clientUpdate=function()
--	-- move to client? no, ok to be here, just need send function
--	local eventsToSend={}
--	for k,event in pairs(_unprocessed) do
--		processEvent(event)
--		if _shouldSendEvent(event) then
--			table.insert(eventsToSend,event)
--		end
--	end
	
--	if next(eventsToSend)~=nil then
--		sendToServer(eventsToSend)
--	end
	
--	cleanEvents()

--end

--local serverUpdate=function()
	-- wip 
--	if next(_unprocessed)~=nil then
--		-- server filters events for each client, so unprocessed here
--		for k,event in pairs(_unprocessed) do
--			processEvent(event)
--		end
		
--		-- shouldSendEvent проверяется внутри
--		Server.sendEventsToClients(_unprocessed)
--	end
	
--	cleanEvents()
--end

	




_.init=function(pow)
	_pow=pow
	_id=pow.id
	_netState=pow.net.state
	_serialize=pow.serialize
	_deserialize=pow.deserialize
end


return _