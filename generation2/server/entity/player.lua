local _={}

_.new=function()
	local result=BaseEntity.new("player")
	
	result.name='Joe'
	result.level='start'
	
	
	return result
end


return _