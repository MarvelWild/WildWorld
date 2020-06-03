local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	result.origin_x=2
	result.origin_y=2
	result.is_item=true
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

return _