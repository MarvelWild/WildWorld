-- global EnergyBehaviour

local _={}

 _.changeEnergy=function(actor, delta)
	actor.energy=actor.energy+delta
	
	if actor.energy<0 then
		actor.energy=0
	end
end


return _