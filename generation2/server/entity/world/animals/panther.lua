local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="pantera"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.footX=15
	result.footY=11
	
	result.mountX=12
	result.mountY=5
	result.move_speed=30
	
	return result
end

_.updateAi=function(entity)
--	log("panthera update ai")
	
	AiService.moveRandom(entity)

end

_.interact=Mountable.toggle_mount




return _