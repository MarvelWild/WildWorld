-- global Debug
local debug={}

debug.useConsole=true
debug.useFile=false
debug.messages={}

local channels={}

local netChannel={
	name="net",
	useConsole=false,
	useFile=true,
	messages={},
}

channels.net=netChannel

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
	
	-- TODO: write stack if error message
	local preparedMessage = Session.frame.."\t"..message
	
	if debug.useFile then 
		if channelName then
			local channel=channels[channelName]
			if not channel then
				channel=newChannel(channelName)
				channels[channelName]=channel
			end
			
			table.insert(channel.messages, preparedMessage) 
		else
			table.insert(debug.messages, preparedMessage) 
		end
	end
	
	if debug.useConsole then
		local consoleMessage
		if channelName then
			consoleMessage="["..channelName.."] "..preparedMessage
		else
			consoleMessage=preparedMessage
		end
		
		consoleMessage=Util.oneLine(consoleMessage)
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


return debug