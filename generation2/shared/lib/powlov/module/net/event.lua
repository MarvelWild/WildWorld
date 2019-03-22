-- connected to pow.net.event
--[[ responsible for receiving, processing events

]]--

local _={}


-- init after Pow

-- key=cmd
-- val=handler
local _eventHandlers={}

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
		login		specified login (private chat). field:targetLogin
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
	if (_externalProcessor~=nil) then
		_externalProcessor(event)
	end

	
	if shouldSkipEvent(event) then 
		log("skip event:".._.toString(event))
		return
	end
	
	doProcessEvent(event)
end



_.earlyUpdate=function()
	
end

_.process=function(event)
	processEvent(event)
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
_.addHandler=function(eventCode, handler)
	local oldHandler=_eventHandlers[eventCode]
	assert(oldHandler==nil)
	_eventHandlers[eventCode]=handler
end

return _