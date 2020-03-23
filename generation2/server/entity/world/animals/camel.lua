local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="camel"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.footX=33
	result.footY=63
	
	result.mountX=28
	result.mountY=44
	
	Mountable.init(result)
	
	return result
end

_.updateAi=function(entity)
	AiService.moveRandom(entity)

end



_.interact=Mountable.toggle_mount

return _