-- connected to pow.net.event

local _={}

local _unprocessed={}
local _nextFrameEvents={}
local _isUpdatedThisFrame=false

-- todo: events can reside in _nextFrameEvents, so this does not represent all events
_.unprocessed=_unprocessed


-- key=cmd
-- val=handler
local _eventHandlers={}

local _pow
local _id
local _netState
local _serialize
local _deserialize


_.onEventProcessing=nil -- func(event)

_.toString=function(event)
	local result=event.id.." t:"..event.target..' c:'..event.code
	
	return result
end


-- now they deleted in 

-- remote/detached
_.register=function(event)
	log("register event:".._.toString(event))
	
	if _isUpdatedThisFrame then
		table.insert(_nextFrameEvents,event)
	else
		table.insert(_unprocessed,event)
	end

end

-- code=eventCode
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
	
	local ourLogin=_netState.login
	if target=="server" then
		if _netState.isClient then
			return true 
		end
	elseif target=="self" then
		if event.login~=ourLogin then
			return true 
		end
	elseif target=="others" then
		if event.login==ourLogin then
			return true 
		end
	elseif target=="login" then
		if event.targetLogin~= ourLogin then
			return true
		end
	end
	
	return false
end




-- move processing logic outside? no, connect handlers to this module
-- without queue, without checks
local doProcessEvent=function(event)
	log("doProcessEvent:".._.toString(event))
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
	-- todo opt
	if (_.onEventProcessing~=nil) then
		_.onEventProcessing(event)
	end

	
	if shouldSkipEvent(event) then 
		log("skip event:".._.toString(event))
		return
	end
	
	doProcessEvent(event)
end





_.earlyUpdate=function()
	_isUpdatedThisFrame=false
	
	if next(_nextFrameEvents)~=nil then
		for k,event in pairs(_nextFrameEvents) do
			table.insert(_unprocessed,event)
		end
		
		table.clear(_nextFrameEvents)
	end
end


-- called from pow.update
_.update=function()
	if (next(_unprocessed)~=nil) then
		log('processing events')
	end
	
	
	for k,event in pairs(_unprocessed) do
		processEvent(event)
	end
	
	_isUpdatedThisFrame=true
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
	
	-- todo: remove debug code
	if (next(_unprocessed)~=nil) then
		log('cleaning events')
		log(Pow.pack(_unprocessed))
	end
	
	
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

-- handler sig: handler(event)
_.addHandler=function(eventCode, handler)
	local oldHandler=_eventHandlers[eventCode]
	assert(oldHandler==nil)
	_eventHandlers[eventCode]=handler
end

return _