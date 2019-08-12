local _={}

_.entityName="portal"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="portal"
	
	return result
end

-- wip: use function

return _