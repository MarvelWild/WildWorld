local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="horse_small"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.footX=17
	result.footY=22
	
	result.mountX=17
	result.mountY=16
	
	result.move_speed=28
	
	return result
end

_.updateAi=function(entity)
	if entity.mounted_by==nil then
		AiService.moveRandom(entity)
	end
end

_.interact=Mountable.toggle_mount




return _