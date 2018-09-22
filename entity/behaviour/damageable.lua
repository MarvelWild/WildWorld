-- global DamageableBehaviour

local _={}

_.takeDamage=function(actor,amount)
	
	-- wip: check for <=0
	
	actor.hp=actor.hp-amount
	
end


return _