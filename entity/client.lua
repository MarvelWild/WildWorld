local _={}

-- static

_.responseHandlers={}

loadScripts("client/handlers/", _.responseHandlers)

_.singleResponseHandlers={}

-- incomplete part accumulated here
local receiveBuffer=""

-- data is raw string, chunk of data flow (could be fragmented)
local recv=function(data) -- search alias: receive
	if not Allen.endsWith(data,NET_MSG_SEPARATOR) then
		-- todo: process completed parts
		receiveBuffer=receiveBuffer+data
		log("received incomplete data. buffering:"..data)
		return
	end
	
	if receiveBuffer~="" then
		data=receiveBuffer+data
		receiveBuffer=""
	end
	
	log("recv:"..data, "net")	
	
	local isProcessed=false
	local dataParts=string.split(data,NET_MSG_SEPARATOR)
	
	for k,dataCommand in pairs(dataParts) do
		local response=TSerial.unpack(dataCommand)
		
		-- todo: mem leak
		local singleHandler=_.singleResponseHandlers[response.requestId]
		if singleHandler~=nil then
			singleHandler(response)
			_.singleResponseHandlers[response.requestId]=nil
			isProcessed=true
		end
		
		
		local handler=_.responseHandlers[response.cmd]
		if handler~=nil then 
			handler(response)
			isProcessed=true
		end
	
		if not isProcessed then
			log("error:data from server not processed:"..data)
		end
		
	end
end

-- static end

_.new=function()
	local result=BaseEntity.new()
	result.entity="Client"
	result.id=nil -- we are service, no serialization
	result.isActive=true
	result.tcpClient=nil
	
	
	Entity.register(result)
	
	return result
end

_.requestId=1

-- единственная точка через которую клиент отправляет сообщения
-- onResponse=function(response)
_.send=function(data, onResponse)
	data.requestId=_.requestId
	_.requestId=_.requestId+1
	
	if onResponse~=nil then
		_.singleResponseHandlers[data.requestId]=onResponse
	end
	
	local packed=TSerial.pack(data)
	log("send cmd:"..data.cmd.." data:"..packed, "net")
	
	local tcpClient=ClientEntity.tcpClient
	tcpClient:send(packed..NET_MSG_SEPARATOR)
end

local afterJoin=function(response)
	log("after join")
	
	for k,entity in pairs(response.entities) do
		-- можно порефакторить в entity.acceptRemote, оно ещё на приёме трансфера есть
		entity.isRemote=true
		entity.aiEnabled=false
		Entity.register(entity)
	end
end


local afterLogin=function(response)
--	local players=response.players
--	local state=require "client/state_pick_player"
--	state.init(players)
--	switchState(state)
--	_.isLoggedIn=true
	log("after login")
	
	assert(CurrentPlayer)
	local data={
		cmd="join",
		player=CurrentPlayer
	}
	_.send(data,afterJoin)

end

local login=function()
	local data={
		cmd="login",
		login=Session.login,
	}
	
	Session.login=data.login
	_.send(data,afterLogin)
end



local handshake=">>"
local port=Session.port
local host
--host="2620:9b::1953:9fbe"
--host="25.83.159.190"
--host="224-425-777.local"
--host="lore"
host=Arg.get("server=","localhost")





_.activate=function(client)
	log("client activate")

	local tcpClient=Grease.tcpClient()
	client.tcpClient=tcpClient
	tcpClient.handshake=handshake
	tcpClient.callbacks.recv=recv
end

_.connect=function(client)
	local ok, msg = client.tcpClient:connect(host, port, false)
	if not ok then
		log("error:Cannot connect:"..msg.." host:"..host.." port:"..port)
		return
	else
		log("connect ok")
	end
	login()
end



_.update=function(client, dt)
	-- log("server update")
	client.tcpClient:update(dt)
end


return _