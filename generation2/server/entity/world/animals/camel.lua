local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="camel"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=33
	result.foot_y=63
	
	result.mountX=28
	result.mountY=44
	
	Mountable.init(result)
	Colored.set_random_color(result)
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity, 10)

end



_.interact=Mountable.toggle_mount

return _