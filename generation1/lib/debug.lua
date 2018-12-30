-- global Debug

-- requirements
-- global Session (search code for usage)

local debug={}

debug.useConsole=true
debug.useFile=false
debug.messages={}


local _contexts={}
local channels={}

local netChannel={
	name="net",
	useConsole=false,
	useFile=true,
	messages={},
}

channels.net=netChannel

-- todo: настройка какие из ченнелов попадают в мейн
-- todo: multichannel messages

local newChannel=function(name)
	local result={}
	result.name=name
	result.useConsole=debug.useConsole
	result.useFile=debug.useFile
	result.messages={}
	
	return result
end


debug.log=function(message,channelName)
	-- local time = love.timer.getTime() -- "\t"..time
	
	if string.find(message,"error") then
		Session.hasErrors=true
		message=message+"\n"+_traceback()
	elseif string.find(message,"warn") then
		Session.hasWarnings=true
		message=message+"\n"+_traceback()
	end
	
	
	local preparedMessage = Session.frame.."\t"
	

	
	
	
	if debug.useConsole and channelName then
		preparedMessage=preparedMessage.."["..channelName.."]\t"
	end
	
	-- contexts
	local hasContexts=false
	local contextsText=""
	for k,context in ipairs(_contexts) do
		if hasContexts then
			contextsText=contextsText+","
		end
		
		
		contextsText=contextsText+context
		hasContexts=true
	end
	
	if hasContexts then
		preparedMessage=preparedMessage+"|"+contextsText+"|\t"
	end	
	
	preparedMessage=preparedMessage..message
	
	if debug.useFile then 
		if channelName then
			local channel=channels[channelName]
			if not channel then
				channel=newChannel(channelName)
				channels[channelName]=channel
			end
			
			table.insert(channel.messages, preparedMessage) 
			
			-- trace log, full timeline
			table.insert(debug.messages, preparedMessage)
		else
			table.insert(debug.messages, preparedMessage) 
		end
	end
	
	if debug.useConsole then
		local consoleMessage
		if not Config.isFullLog then
			consoleMessage=Util.oneLine(preparedMessage)
		else
			consoleMessage=preparedMessage
		end

		print(consoleMessage)
	end
end

local writeChannels=function()
	for k,channel in pairs(channels) do
		local log = ""
	
		for k2, message in ipairs(channel.messages) do
			log=log..message.."\n"
		end
		
		love.filesystem.append("log_"..channel.name..".txt", log)
		channel.messages={}
	end
end


-- вызывать например из love.quit, и в других gc friendly местах
debug.writeLogs=function()
	if  debug.useFile then
		local log = ""
		
		for k, v in ipairs(debug.messages) do
			log=log..v.."\n"
		end
		
		love.filesystem.append("log.txt", log)
		
		debug.messages={}
	end
	
	writeChannels()
end

debug.enterContext=function(context)
	table.insert(_contexts, context)
end

debug.exitContext=function()
	local lastPos=#_contexts
	local context=_contexts[lastPos]
	log("exit context:"..context)
	table.remove(_contexts,lastPos)
end

return debug