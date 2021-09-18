local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="pic1"
	result.is_item=true
	result.origin_x=0
	result.origin_y=15
	
	result.foot_x=0
	result.foot_y=0
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

return _