-- global DamageableBehaviour

local _={}

_.takeDamage=function(actor,amount)
	
	-- todo: check for <=0
	
	actor.hp=actor.hp-amount
	
end


return _