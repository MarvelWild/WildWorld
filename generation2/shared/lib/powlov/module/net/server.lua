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


-- проверить нужно ли что-то с ним делать на сервере, и 
local processEvent=function()
	-- wip
end


local processEvents=function()
	if next(_unprocessedEvents)==nil then return end
	-- server filters events for each client, so unprocessed here
	for k,event in pairs(_unprocessedEvents) do
		processEvent(event)
	end
	
	-- wip
	-- shouldSendEvent проверяется внутри
	Server.sendEventsToClients(_unprocessed)


	_event.cleanEvents()
end


_.update=function(dt)
	if _tcpServer==nil then return end
	
	processEvents()
	
	-- log('server upd')
	_tcpServer:update(dt)
end




_.addHandler=function(cmd,handler)
	local existingCommand=_responseHandlers[cmd]
	if existingCommand~=nil then
		log("error:multiple nahdlers for same command is not supported")
		return
	end
	
	_responseHandlers[cmd]=handler
	
end




return _