local _entity_name='EnergyService'
local _=BaseEntity.new(_entity_name, true)

local calc_energy_decrease=function(entity)
	-- todo factors
	return 0.02
end


_.update_simulation=function()
	-- todo iterate only energy entities
	local entities=Entity.get_all()
	for entity,t in pairs(entities) do
		if entity.energy~=nil then 
			
			entity.energy=entity.energy-calc_energy_decrease(entity)
			
-- почему было закомменчено тут?			
			ServerService.entity_updated(entity)
		end
	end
	
	
	
end


return _