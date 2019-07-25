local _={}

-- todo: from file name
_.entityName="panther"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="pantera"
	
	return result
end




return _