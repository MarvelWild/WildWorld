local _={}

_.new=function()
	local result=BaseEntity.new("player")
	
	result.name='Joe'
	
	
	return result
end


return _