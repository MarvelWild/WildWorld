-- connected to pow.net.event
--[[ responsible for receiving, processing events

]]--

local _={}


-- init after Pow

-- key=cmd
-- val=handler
local _eventHandlers={}

-- key: request event id, val: f()
local _responseHandlers={}

local _pow
local _id
local _netState
local _serialize
local _deserialize


-- for networking hook
local _externalProcessor=nil -- func(event)

_.setProcessor=function(processor)
	assert(_externalProcessor==nil, "multi hander not supported")
	_externalProcessor=processor
end


_.toString=function(event)
	local result=event.id.." t:"..event.target..' c:'..event.code
	
	return result
end





-- code=eventCode
_.new=function(code,requestId)
	log("Event.new:".._traceback(), "verbose")

-- event is not a entity
	local event={}
	
	event.entity_name="Event"
	event.id=_id.new(event.entity_name)
	event.login=_netState.login
	if requestId~=nil then
		event.requestId=requestId
	end
	
	
	-- alias doNotSend
	-- client do not send remote event to server, and should mark received as remote
	event.isRemote=nil
	
	--[[
		all			all levels
		self		
		server	
		others	except self
		login		specified login (private chat). field:targetLogin
		level		everyone on same level as event.level
	]]--
	event.target="all"
	event.targetLogin=nil
	
	-- по коду определяем обработчик
	event.code=code
	
	-- deprecated. use event.process(event)
	--_.register(event)
	
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
	elseif target=="level" then
		if _netState.isClient then
			-- todo: GameState shouldn't be used here
			local currentPlayer=GameState.getPlayer()
			if currentPlayer~=nil then
				local currentLevel=currentPlayer.level_name
				if (currentLevel~=event.level) then
					log("warn: skipping level event (probably not supposed to receive it). currentLevel="..tostring(currentLevel)..
						" event.level:"..tostring(event.level))
					return true
				else
					return false
				end
			else
				-- its ok
				-- log("warn:received level event when no player")
			end
			
		else -- server
			if event.do_not_process_on_server then return true end
			-- always skip on server
			-- now always execute
			--return true 
			return false
		end
	elseif target=="all" then			
		return false		
	else
		log("error: unknown event target")
	end
	
	return false
end




-- move processing logic outside? no, connect handlers to this module
-- without queue, without checks
local doProcessEvent=function(event)
	log("doProcessEvent:".._.toString(event),'event')
	local eventCode=event.code
	
	local handler=_eventHandlers[eventCode]
	if handler~=nil then
		log("processing event:".._.toString(event).." full:".._serialize(event), "event")
		handler(event)
	else
		local requestId=event.requestId
		if requestId~=nil then
			--_responseHandlers
			local handler=_responseHandlers[requestId]
			if handler~=nil then
				handler(event)
				_responseHandlers[requestId]=nil
			else
				log("error:event unprocessed:".._serialize(event))
			end
		else
			-- should be registered in _eventHandlers by creating
			-- event/name.lua. autoloaded from there
			log("error:event unprocessed:".._serialize(event))
		end
	end
end



local processEvent=function(event)
	-- _externalProcessor is net sender
	-- connected from server/client onEventProcessing-sendEvent
	if (_externalProcessor~=nil) then
		_externalProcessor(event)
	end

	
	if shouldSkipEvent(event) then 
		log("skip event:".._.toString(event),'event')
		return
	end
	
	doProcessEvent(event)
end


-- todo: doc
_.earlyUpdate=function()
	
end

_.process=function(event,onResponse)
	processEvent(event)
	
	if onResponse~=nil then
		local eventId=event.id
		_responseHandlers[eventId]=onResponse
	end
	
		
end



-- called from pow.update
--_.update=function()
--end



_.init=function(pow)
	_pow=pow
	_id=pow.id
	_netState=pow.net.state
	_serialize=pow.serialize
	_deserialize=pow.deserialize
end

-- handler sig: handler(event)
_.add_handler=function(eventCode, handler)
	local oldHandler=_eventHandlers[eventCode]
	assert(oldHandler==nil)
	_eventHandlers[eventCode]=handler
end

return _