local _={}

local log=Debug.log
local startsWith=Allen.startsWith

-- example: get("bind=","*") returns: "127.0.0.1" from bind=127.0.0.1 cmd param
_.get=function(prefix,fallback)
	for k,currentArg in pairs(arg) do
--		log("processing arg:"..currentArg)
		local pos= string.find(currentArg, prefix)
		
		if pos~=nil then
		
			local prefixLen=string.len(prefix)
			local value=string.sub(currentArg,pos+prefixLen)
			return value
		end
	end
	
	return fallback
end

return _