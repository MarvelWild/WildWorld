-- привязанность

local _={}


_.add=function(source,target,amount)
	if not target.bond then target.bond={} end
	
	local bond=target.bond
	
	local source_string_ref=Entity.get_string_reference(source)
	
	local bond_with_source=bond[source_string_ref]
	
	if not bond_with_source then 
		bond_with_source=0
	end
	
	local new_bond=bond_with_source+amount
	
	bond[source_string_ref]=new_bond
end


return _