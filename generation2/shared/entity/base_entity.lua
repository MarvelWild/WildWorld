local _={}

_.new=function(entity)
	local result={}
	
	result.id=Id.new(entity)
	result.entity=entity
	
	
	return result
end



return _