local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="pantera"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

_.updateAi=function(entity)
--	log("panthera update ai")
	
	AiService.moveRandom(entity)

end





return _