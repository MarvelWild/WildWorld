local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=7
	result.foot_y=14
	
	result.mountX=6
	result.mountY=7
	
	result.move_speed=24
	
	return result
end

_.updateAi=function(entity)
	if entity.mounted_by==nil then
		AiService.moveRandom(entity)
	end
end

_.interact=Mountable.toggle_mount

return _