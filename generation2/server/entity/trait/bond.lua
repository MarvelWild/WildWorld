-- global Bond
-- привязанность

local _={}



-- from horse
-- to human
_.add=function(from,to,amount)
	if not from.bond then from.bond={} end
	
	local bond=from.bond
	
	local source_string_ref=Entity.get_string_reference(to)
	
	local bond_with_source=bond[source_string_ref]
	
	if not bond_with_source then 
		bond_with_source=0
	end
	
	local new_bond=bond_with_source+amount
	
	bond[source_string_ref]=new_bond
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