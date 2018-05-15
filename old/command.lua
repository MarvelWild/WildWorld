local _={}

_.new=function(code)
	local result={}
	
	result.code=code
	
	-- replaces prev command with same code
	result.isSingle=true
	result.x=0
	result.y=0
	
	return result
end

_.stop=function(command)
	-- implement if needed
end


return _