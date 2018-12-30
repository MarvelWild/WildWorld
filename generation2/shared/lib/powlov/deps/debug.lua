-- global Debug

-- requirements
-- global Session (search code for usage)

local _debug={}


-- connected from uplib
_debug.pow=nil

_debug.useConsole=true
_debug.useFile=true
_debug.messages={}


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
	result.useConsole=_debug.useConsole
	result.useFile=_debug.useFile
	result.messages={}
	
	return result
end



_debug.log=function(message,channelName)
	-- local time = love.timer.getTime() -- "\t"..time
	
	if string.find(message,"error") then
		-- todo: reimplement
		-- Session.hasErrors=true
		message=message+"\n"+debug.traceback()
	elseif string.find(message,"warn") then
		-- Session.hasWarnings=true
		message=message+"\n"+debug.traceback()
	end
	
	
	local preparedMessage = _debug.pow.getFrame().."\t"
	

	
	
	
	if _debug.useConsole and channelName then
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
	
	if _debug.useFile then 
		if channelName then
			local channel=channels[channelName]
			if not channel then
				channel=newChannel(channelName)
				channels[channelName]=channel
			end
			
			table.insert(channel.messages, preparedMessage) 
			
			-- trace log, full timeline
			table.insert(_debug.messages, preparedMessage)
		else
			table.insert(_debug.messages, preparedMessage) 
		end
	end
	
	if _debug.useConsole then
		local consoleMessage
-- todo: reimplement		
--		if not Config.isFullLog then
--			consoleMessage=Util.oneLine(preparedMessage)
--		else
			consoleMessage=preparedMessage
--		end

		print(consoleMessage)
	end
end

local writeChannels=function()
	local writeChannel=function(channel)
		local log = ""
		
		for k, message in ipairs(channel.messages) do
			log=log..message.."\n"
		end
		
		love.filesystem.append("log_"..channel.name..".txt", log)
		channel.messages={}
	end
	
	
	for k,channel in pairs(channels) do
		if channel.useFile then
			writeChannel(channel)
		end
	end
end


-- вызывать например из love.quit, и в других gc friendly местах
_debug.writeLogs=function()
	if  _debug.useFile then
		local log = ""
		
		for k, v in ipairs(_debug.messages) do
			log=log..v.."\n"
		end
		
		love.filesystem.append("log.txt", log)
		
		_debug.messages={}
	end
	
	writeChannels()
end

_debug.enterContext=function(context)
	table.insert(_contexts, context)
end

_debug.exitContext=function()
	local lastPos=#_contexts
	local context=_contexts[lastPos]
	log("exit context:"..context)
	table.remove(_contexts,lastPos)
end

return _debug