local _={}

_.new=function()
	local result=BaseEntity.new()
	result.entity="Server"
	result.id=nil -- we are service, no serialization
	result.isActive=true
	result.tcpServer=nil
	
	Entity.register(result)
	
	return result
end

-- Static
_.clientsByLogin={}
_.loginByClient={}
_.commandHandlers={}
loadScripts("server/handlers/", _.commandHandlers)

_.registerClient=function(clientId,login)
	_.clientsByLogin[login]=clientId
	_.loginByClient[clientId]=login
end

local prepareEventsForLogin=function(login,events)
	local result={}
	
	for k,event in pairs(events) do
		if event.login~=login then
			table.insert(result,event)
		end
	end
	
	return result
end


_.sendEventsToClients=function(events)
	for login,client in pairs(_.clientsByLogin) do
		local preparedEvents=prepareEventsForLogin(login,events)
		
		if next(preparedEvents)~=nil then
			local command=
			{
				cmd="events_client",
				events=events
			}
			-- wip: exclude own event for each client
			-- wip: login? и проверить чтобы в мире тоже был, изначальном
			Server.send(command)
		else
			log("no events for:"..login)
		end
	end
	

	-- wip: проверяем на клиенте что пришло
end



-- единственная точка через которую сервер отправляет сообщения
_.send=function(data, clientId,requestId)
	data.requestId=requestId
	local packed=pack(data)
	
	local sendLen=string.len(packed)
	local sendInfo="sending size="..sendLen
	if sendLen<8192 then
		sendInfo=sendInfo.." data:"..packed
	end
	log(sendInfo)
	
	ServerEntity.tcpServer:send(packed..NET_MSG_SEPARATOR, clientId)
end


-- static end

local connect=function(id)
	-- id is userdata if tcp
	log("Client connected")

	-- report back to the client with ID
	--self:sendWelcome(id)
	--self:sendSnapshot(id)	
end

local recv=function(data, id)
	log("recv:"..data)
	local dataParts=string.split(data,NET_MSG_SEPARATOR)
	
	for k,dataCommand in pairs(dataParts) do
		local command=TSerial.unpack(dataCommand)
		local handler=_.commandHandlers[command.cmd]
		if handler==nil then 
			log("error: no handler for cmd:"..command.cmd) 
		else
			handler(command,id)
		end
	end
end

local disconnect=function(ip, port)
	log("disconnect:"..ip..":"..port)
end

local handshake=">>"
local port="8421"

_.activate=function(server)
	log("server activate")
	
	local tcpServer=Grease.tcpServer()
	server.tcpServer=tcpServer
	local callbacks=tcpServer.callbacks
	callbacks.connect=connect
	callbacks.recv=recv
	callbacks.disconnect=disconnect
	tcpServer.handshake=handshake
	
	tcpServer:listen(port)
	log("tcp server started on "..port)
end


_.update=function(server,dt)
	-- log("server update")
	server.tcpServer:update(dt)
end


return _