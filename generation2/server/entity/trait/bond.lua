-- global Bond
-- привязанность
-- хранится в сущности от которой привязка в свойстве .bond={to_string_ref=value}

local _={}



-- from horse
-- to human
_.add=function(from,to,amount)
	if not from.bond then from.bond={} end
	
	local bond=from.bond
	
	local to_string_ref=Entity.get_string_reference(to)
	
	local bond_value=bond[to_string_ref]
	
	if not bond_value then 
		bond_value=0
	end
	
	local new_bond=bond_value+amount
	
	bond[to_string_ref]=new_bond
end

-- from например horse
-- to например humanoid
_.get=function(from,to)
	local bond=from.bond
	if not bond then return 0 end
	
	local key=Entity.get_string_reference(to)
	
	local result=bond[key] or 0
	
	return result
end



return _