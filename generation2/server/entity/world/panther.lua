local _={}

-- todo: from file name
_.entityName="panther"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="pantera"
	
	return result
end

_.updateAi=function(entity)
	log("panthera update ai")
	
	AiService.moveRandom(entity)

end





return _