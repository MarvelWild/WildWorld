local _={}

_.new=function()
	local result=BaseEntity.new()
	result.entity="Pointer"
	result.id=nil -- we are service, no serialization
	result.isActive=true
	
	Entity.register(result)
	
	return result
end

return _