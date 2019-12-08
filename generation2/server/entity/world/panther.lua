local _={}

_.entityName=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="pantera"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

_.updateAi=function(entity)
--	log("panthera update ai")
	
	AiService.moveRandom(entity)

end





return _