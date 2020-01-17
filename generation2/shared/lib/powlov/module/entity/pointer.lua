-- точка для поиска коллизий
local _={}
_.entity_name="pointer"
_.new=function()
	local result=BaseEntity.new(_.entity_name,true)
	
	return result
end

return _