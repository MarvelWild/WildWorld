local debug={}

debug.useConsole=true
debug.useFile=false
debug.messages={}

debug.log=function(message)
	-- TODO: console
	-- local time = love.timer.getTime() -- "\t"..time
	
	-- TODO: write stack if error message
	local preparedMessage = Session.frame.."\t"..message
	
	if debug.useFile then table.insert(debug.messages, preparedMessage) end
	
	if debug.useConsole then
		print(preparedMessage)
	end
	
end

-- вызывать например из love.quit
debug.writeLogs=function()
	if not debug.useFile then return end
	local log = ""
	
	for k, v in ipairs(debug.messages) do
		log=log..v.."\n"
	end
	
	love.filesystem.append("log.txt", log)
	
	debug.messages={}
end


return debug