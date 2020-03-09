local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="jiraffe"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.mountX=15
	result.mountY=23
	
	result.originX=15
	result.originY=23
	
	result.footX=15
	result.footY=31
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)

end

_.interact=Mountable.toggle_mount




return _