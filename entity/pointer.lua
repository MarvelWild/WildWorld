local _={}
_.name="Pointer"
_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.id=nil -- we are service, no serialization
	result.isActive=true
	
	Entity.afterCreated(result,_,options)
	
	return result
end

return _