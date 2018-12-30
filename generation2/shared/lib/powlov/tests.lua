local pathOfThisFile = ...
local folderOfThisFile = string.sub(pathOfThisFile, 0, string.len(pathOfThisFile)-6)

local _={}

local _pow

local testReceiver=function()
	
	local _receiver=_pow.receiver
	local shared=require(folderOfThisFile.."/module/net/shared")
	local netMsgSeparator=shared.netMsgSeparator
	
	local receiver=_receiver.new()
	
	
	local messages=_receiver.receive(receiver, "incomplete")
	
	local count=#messages
	assert(count==0)
	assert(receiver.buffer=="incomplete")
	
	local receiver2=_receiver.new()
	local messages2=_receiver.receive(receiver2, "hello"..netMsgSeparator)
	local count2=#messages2
	assert(count2==1)
	assert(messages2[1]=="hello")
	assert(receiver2.buffer=="")
	
	
	local receiver3=_receiver.new()
	local messages3=_receiver.receive(receiver3, "hello"..netMsgSeparator.."incomplete")
	local count3=#messages3
	assert(count3==1)
	assert(messages3[1]=="hello")
	assert(receiver3.buffer=="incomplete")
	
	
	local receiver4=_receiver.new()
	local messages4=_receiver.receive(receiver4, "hello"..netMsgSeparator.."complete"..netMsgSeparator)
	local count4=#messages4
	assert(count4==2)
	assert(messages4[1]=="hello")
	assert(messages4[2]=="complete")
	assert(receiver4.buffer=="")
end


_.run=function(pow)
	_pow=pow
	testReceiver()
end

	
	
return _