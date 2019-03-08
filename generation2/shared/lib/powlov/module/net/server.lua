-- pow server
-- generic game network abstraction
-- Hides Grease

local pathOfThisFile = ...
-- 4 is a length(thisFile) - this file
local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-7)


local _={}

local _log

local _grease
local _tcpServer

local _endsWith
local _msgSeparator
local _unpack
local _pack

-- state

local _receiver=nil
local _event=nil
local _unprocessedEvents=nil

local _singleResponseHandlers={}
local _loginByClient={}
local _clientByLogin={}

-- k=cmd, v=handler
local _responseHandlers={}

-- state end

local _split=string.split


local _shared=require(folderOfThisFile.."/shared")

local _netState


local _registerClient=function(clientId,login)
	_loginByClient[clientId]=login
	_clientByLogin[login]=clientId
end


local _login=function(data, clientId, requestId)
	log("login "..Pow.inspect(data))
	
	_registerClient(clientId, data.login)
	
	local response={status="ok", login=data.login}
	_.send(response, clientId, requestId)
end



_.init=function(pow)
	_log=pow.log
	_grease=pow.grease
	_endsWith=pow.allen.endsWith
	_msgSeparator=_shared.netMsgSeparator
	_unpack=pow.tserial.unpack
	_pack=pow.tserial.pack
	_.addHandler("login", _login)
	
	_receiver=pow.receiver
	_event=pow.net.event
	_netState=pow.net.state
	_unprocessedEvents=_event.unprocessed
end


local connect=function()
	log('client connected')
end


local _clientReceivers={}


local getClientReceiver=function(clientId)
	local result=_clientReceivers[clientId]
	if result==nil then
		result=_receiver.new()
		_clientReceivers[clientId]=result
	end
	
	return result
end


-- data is string
-- client id is userData. example: tcp{client}: 00000000253C2A28
local recv=function(data, clientId)
	local receiver=getClientReceiver(clientId)
	local receivedMessages
	receivedMessages=_receiver.receive(receiver, data)
	
	for k,message in ipairs(receivedMessages) do
		local isProcessed=false
		local response=_unpack(message)
		local requestId=response.requestId
		
		-- todo single handler
		
		local handler=_responseHandlers[response.cmd]
		if handler~=nil then
			handler(response, clientId, requestId)
			isProcessed=true
		end
		
			
		if not isProcessed then
			_log("error:net msg not processed:"..message)
		end
		
	end
	
	
--	for k,dataCommand in pairs(dataParts) do
--		local response=_unpack(dataCommand)
		
--		local requestId=response.requestId
--		local singleHandler=_singleResponseHandlers[requestId]
--		if singleHandler~=nil then
--			singleHandler(response)
--			_singleResponseHandlers[requestId]=nil
--			isProcessed=true
--		end
--	end
end

-- единственная точка через которую сервер отправляет сообщения
_.send=function(data,clientId,requestId)
	data.requestId=requestId
	local cmd=data.cmd
	
	local packed=_pack(data)
	
	local sendLen=string.len(packed)
	local login=_loginByClient[clientId]
	
	if requestId==nil then requestId="nil" end
	if cmd==nil then cmd="nil" end
	local sendInfo="send: rqid="..requestId.." to:"..tostring(login).." cmd="..cmd.." size="..sendLen.." data:"..packed
	log(sendInfo, "net")
	
	_tcpServer:send(packed.._msgSeparator, clientId)
end

local disconnect=function()
	log('serv disconnect')	
end



_.listen=function(port)
	-- todo: option to disable pow inner log messages
	local host=ConfigService.serverListen
	
	-- todo
	if (_tcpServer~=nil) then
		_log("error: already listening")
		return
	end
	_tcpServer=_grease:tcpServer()
	local callbacks=_tcpServer.callbacks
	callbacks.connect=connect
	callbacks.recv=recv
	callbacks.disconnect=disconnect
	
	_tcpServer.handshake=_shared.handShake
	
	_tcpServer:listen(host, port)
	
	_log("listening at:"..host..":"..port)
end









_.update=function(dt)
end

---- login is recipient login, nil means broadcast (for server)
local shouldSendEvent=function(event,targetLogin)
	local target=event.target
	
	local result=true
	local ourLogin=_netState.login
	local sourceLogin=event.login
	
	-- source==taget
	if sourceLogin==targetLogin then -- не нужно возвращать отправителю
		result=false
	elseif targetLogin==ourLogin then -- не нужно слать себе
		result=false 
	elseif target=="others" then 
		 result=true
	elseif target=="server" then 
		-- эти только принимаем
		result=false 
	elseif target=="self" then 
		result=false 
	elseif target=="login" then
		if event.targetLogin~=targetLogin then
			result=false
		else 
			result=true
		end
	elseif target=="all" then 
		result=true
	else
		log("error:unk event:".._event.toString(event))
	end
	
	log("shouldSendEvent from server:".._event.toString(event).." to login:"..tostring(targetLogin).." result:"..tostring(result))

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


local sendEvents=function()
	if (next(_unprocessedEvents)==nil) then return end
	
	for login,client in pairs(_clientByLogin) do
		local preparedEvents=prepareEventsForLogin(login,_unprocessedEvents)
	
		if next(preparedEvents)~=nil then
			local command=
			{
				cmd="events_client",
				events=preparedEvents
			}
			
			for k,event in pairs(preparedEvents) do
				log("sending event:".._event.toString(event))
			end
			
			_.send(command,client)
		else
			log("no events for:"..login)
		end

	end
end


-- should be called after pow.update (it handles events)
_.lateUpdate=function(dt)
	if _tcpServer==nil then return end
	

	sendEvents()
	-- log('server upd')
	_tcpServer:update(dt)
end






-- handler sig:  handler(response, clientId, requestId)
_.addHandler=function(cmd,handler)
	local existingCommand=_responseHandlers[cmd]
	if existingCommand~=nil then
		log("error:multiple nahdlers for same command is not supported")
		return
	end
	
	_responseHandlers[cmd]=handler
	
end


-- receive
local handleEvents=function(response, clientId, requestId)
	local events=response.events
	for k,event in pairs(events) do
		_event.register(event)
	end
end


_.addHandler("events", handleEvents)



return _