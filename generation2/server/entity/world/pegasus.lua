local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="pegasus"
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

_.updateAi=function(entity)
--	log("pegasus update ai")
	
	-- todo: enable after mount
	-- AiService.moveRandom(entity)

end

_.interact=function(actor,target)
	Mountable.toggle_mount(actor,target)
end



return _