local _={}

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.energy=10
	result.maxEnergy=10
	
	return result
end

_.slowUpdate=function(animal)
	log("animal slow update")
	
	EnergyBehaviour.changeEnergy(animal, -0.01)
end

return _