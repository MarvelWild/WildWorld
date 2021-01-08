-- global Eater
local _={}


local is_edible=function(actor,entity)
	-- todo: generic
	if entity.entity_name=="apple" then
		return true
	end
	
	return false
end


_.get_edible=function(actor,entities)
	local result={}

	for i,entity in pairs(entities) do
		if is_edible(actor,entity) then
			table.insert(result,entity)
		end
		
	end
	
	return result
end -- get_edible


	



return _