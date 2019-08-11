
local _={}

_.entityName="seed"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="seed"
	
	return result
end

_.updateSimulation=function()
	log('sim seed wip')
end





return _