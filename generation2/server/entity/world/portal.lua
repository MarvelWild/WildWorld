local _={}

_.entityName="portal"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="portal"
	
	result.location="space"
	
	--todo: from sprite
	result.w=10
	result.h=9
	
	
	return result
end


return _