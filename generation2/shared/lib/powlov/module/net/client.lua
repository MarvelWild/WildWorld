-- pow client module
-- wraps grease

local _={}

local _log

local _grease
local _tcpClient

local _tserial
local _unpack


local pathOfThisFile = ...
-- 4 is a length(thisFile) - this file

-- todo: universal version
local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-7)

local _shared=require(folderOfThisFile.."/shared")

local _netMsgSeparator=_shared.netMsgSeparator
local _singleResponseHandlers={}

-- todo: implement
local _responseHandlers={}

local _receiver
local _receiverInst
local _event

local _netState

-- responds infinitely
_.addHandler=function(cmd, handler)
	assert(_responseHandlers[cmd]==nil)
	
	_responseHandlers[cmd]=handler
end


local handleEvent=function(response)
	local event=response.event
	_event.process(event)
end




-- state
_.requestId=1
-- state end


local recv=function(data) -- search alias: receive
	log('client recv:'..data)
	
	local receivedMessages
	receivedMessages=_receiver.receive(_receiverInst, data)

	for k,message in ipairs(receivedMessages) do
		local isProcessed=false
		local response=_unpack(message)
		local requestId=response.requestId
		
		
		
		local singleHandler=_singleResponseHandlers[requestId]
		if singleHandler~=nil then
			singleHandler(response)
			_singleResponseHandlers[requestId]=nil
			isProcessed=true
		else
			-- todo generic handler
			local cmd=response.cmd
			assert(cmd)
			local handler=_responseHandlers[cmd]
			assert(handler,"No handler for:"..cmd)
			handler(response)
			isProcessed=true
		end
		
		if not isProcessed then
			_log("error:net msg not processed:"..data)
		end
	end
end


-- единственная точка через которую клиент отправляет сообщения
-- onResponse=function(response)
_.send=function(data, onResponse)
	data.requestId=_.requestId
	_.requestId=_.requestId+1
	
	if onResponse~=nil then
		_singleResponseHandlers[data.requestId]=onResponse
	end
	
	local packed=_tserial.pack(data)
	
	-- local readablePacked=serialize(data)
	log("send cmd:"..data.cmd.." data:"..packed, "net")
	
	_tcpClient:send(packed.._netMsgSeparator)
end


_.connect=function(host, port)
	_tcpClient=_grease.tcpClient()
	_tcpClient.handshake=_shared.handShake
	_tcpClient.callbacks.recv=recv
	
	local result=false
	local ok, msg = _tcpClient:connect(host, port, false)
	if not ok then
		--log("error:Cannot connect:"..msg.." host:"..host.." port:"..port)
		result=false
	else
		--log("connect ok")
		result=true
	end
	
	return result, msg
end

local shouldSendEventFromClient=function(event)
	local target=event.target
	local eventLogin=event.login
	local ourLogin=_netState.login
	
	-- на клиенте события можно отправлять только серверу
	local result=true
	
	if eventLogin~=ourLogin then -- чужие не реброадкастим
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
		log("error:unk event:".._.toString(event))
	end
	
	log("shouldSendEventFromClient:".._event.toString(event).." result:"..tostring(result))

	return result
end

local sendEventToServer=function(event)
	local command=
	{
		cmd="event",
		event=event
	}
	
	_.send(command)
end





_.update=function(dt)
	if _tcpClient==nil then return end
	
--	log('client upd')
	_tcpClient:update(dt)
end

-- add networking logic to event queue
local onEventProcessing=function(event)
	if shouldSendEventFromClient(event) then
		sendEventToServer(event)
		log("event sending:"..Pow.pack(event))
	end
end


_.init=function(pow)
	_log=pow.log
	_grease=pow.grease
	_tserial=pow.tserial
	_receiver=pow.receiver
	_receiverInst=_receiver.new()
	_unpack=pow.tserial.unpack
	_event=pow.net.event
	_netState=pow.net.state
	_.addHandler('event', handleEvent)
	
	_event.setProcessor(onEventProcessing)
end

return _
