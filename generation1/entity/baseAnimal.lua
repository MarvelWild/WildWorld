-- aliases: LivingEntity

local _={}

_.name="BaseAnimal"

-- todo: can add children for duck calls

_.new=function(options)
	local result=BaseEntity.new(options)
	
	result.energy=10
	result.maxEnergy=10
	
	
	-- wip
	-- result.ai_state=nil
	
	return result
end

-- per slow update tick
local getEnergyDrainSpeed=function(animal)
	return -0.01
end


_.slowUpdate=function(animal)
	log("animal slow update")
	
	-- todo: networking - process on server, send update command
	EnergyBehaviour.changeEnergy(animal, getEnergyDrainSpeed())
	
	-- log("BaseAnimal.energy changed to:"..animal.energy)
end

return _