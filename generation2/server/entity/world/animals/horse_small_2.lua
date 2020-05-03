local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=18
	result.foot_y=31
	
	result.mountX=22
	result.mountY=23
	
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