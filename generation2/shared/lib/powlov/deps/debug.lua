-- global Debug

-- requirements
-- global Session (search code for usage)

-- todo: show errors always, event if channel is disabled

local _debug={}


-- connected from uplib
_debug.pow=nil

_debug.useConsole=true
_debug.useFile=true
_debug.messages={}


local _contexts={}
local channels={}
_debug.channel=channels

local netChannel={
	name="net",
	useConsole=true,
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

channels.db=newChannel("db")
channels.net=newChannel("net")
channels.event=newChannel("event")

-- todo: alias v
channels.verbose=newChannel("verbose")
channels.entity=newChannel("entity")
channels.input=newChannel("input")
channels.collision=newChannel("collision")

-- todo: too much typing here
channels.move=newChannel("collision")
channels.mount=newChannel("mount")
channels.grow=newChannel("grow")

-- all console settings
channels.entity.useConsole=false
channels.input.useConsole=false
channels.verbose.useConsole=false
channels.verbose.useFile=false
channels.event.useConsole=false
channels.db.useConsole=false
channels.net.useConsole=false
channels.collision.useConsole=false
channels.grow.useConsole=false
channels.move.useConsole=false
channels.mount.useConsole=false


-- used if no channel name provided
local _mainChannel=newChannel("main")
channels.main=_mainChannel


_debug.last_message=""
_debug.prev_message=""

-- forceConsole: show message in console even if its channel is disabled
_debug.log=function(message,channelName,forceConsole)
	-- local time = love.timer.getTime() -- "\t"..time
	
--	if channelName=="entity" then
--	end
	
--	if forceConsole then
--	end
	
	
	
	if string.find(message,"error") then
		-- todo: reimplement
		-- Session.hasErrors=true
		message=message+"\n"+debug.traceback()
	elseif string.find(message,"warn") then
		-- Session.hasWarnings=true
		message=message+"\n"+debug.traceback()
	elseif Pow.allen.startsWith(message,"trace") then
		message=message+"\n"+debug.traceback()
	end
	
	
	local preparedMessage = _debug.pow.get_frame().."\t"
	
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
	
	local channel
	if channelName then
		channel=channels[channelName]
		if not channel then
			channel=newChannel(channelName)
			channels[channelName]=channel
		end
	else
		channel=_mainChannel
	end
	
	if channel.useFile then 
		table.insert(channel.messages, preparedMessage) 
		
		-- trace log, full timeline
		table.insert(_debug.messages, preparedMessage)
	else
		table.insert(_debug.messages, preparedMessage) 
	end
	
	if channel.useConsole or forceConsole then
		local consoleMessage
-- todo: reimplement		
--		if not Config.isFullLog then
--			consoleMessage=Util.oneLine(preparedMessage)
--		else
		consoleMessage=preparedMessage
--		end

		_debug.prev_message=_debug.last_message
		_debug.last_message=consoleMessage
		print(consoleMessage)
	end
end

local writeChannels=function()
	local writeChannel=function(channel)
		local log = ""
		
		for k, message in ipairs(channel.messages) do
			log=log..message.."\n"
		end
		
		love.filesystem.append(_debug.pow.saveDir.."log_"..channel.name..".txt", log)
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
		
		love.filesystem.append(_debug.pow.saveDir.."log.txt", log)
		
		_debug.messages={}
	end
	
	writeChannels()
end


-- extra text to log messages
_debug.enterContext=function(context)
	table.insert(_contexts, context)
end

_debug.exitContext=function()
	local lastPos=#_contexts
	local context=_contexts[lastPos]
	log("exit context:"..context)
	table.remove(_contexts,lastPos)
end


-- todo: implement
-- save table to file, then open it in zero brane
_debug.zbs=function(table)
	
end


return _debug