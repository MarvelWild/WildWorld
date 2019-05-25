-- логика буферизации входящего потока, и выдачи готовых к потреблению блоков

local pathOfThisFile = ...
-- 4 is a length(thisFile) - this file
local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-9)

local _shared=require(folderOfThisFile.."/shared")
local _netMsgSeparator=_shared.netMsgSeparator

local _={}


local _strSplit=nil
local _endsWith=nil

_.init=function(pow)
	_strSplit=pow.string.split
	_endsWith=pow.allen.endsWith
end


-- return receivedMessages
_.receive=function(receiver, newStr)
	
	receiver.buffer=receiver.buffer..newStr
	local buffer=receiver.buffer
	local parts=_strSplit(buffer, _netMsgSeparator)
	local count=#parts
	local isLastPartCompleted=_endsWith(buffer,_netMsgSeparator)
	if not isLastPartCompleted then
		receiver.buffer=parts[count]
		parts[count]=nil
	else
		receiver.buffer=""
	end
	
	return parts
end



_.new=function()
	return {buffer=""}
end



-- frz tests




return _