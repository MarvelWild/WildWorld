-- global BaseEntity

local _={}

_.new=function(entity,isService)
	assert(entity)
	local result={}
	
	if not isService then
		result.id=Id.new(entity)
	end
	result.entity=entity
	
	
	return result
end



return _