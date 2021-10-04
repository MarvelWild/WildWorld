local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="snake"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=20
	result.foot_y=63
	
	
	return result
end

_.updateAi=function(entity)
	Ai.moveRandom(entity)
end

-- _.interact=Mountable.toggle_mount




return _