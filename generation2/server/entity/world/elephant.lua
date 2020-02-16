local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="elephant"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.footX=15
	result.footY=31
	
	result.mountX=15
	result.mountY=21
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)

end

-- todo: think easy mountable init, from prop
_.interact=Mountable.toggle_mount





return _