local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="wall"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	-- todo: implement
	result.is_solid=true
	
	
	return result
end


return _