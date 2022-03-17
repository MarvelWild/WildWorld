local _={}

local _entities={}
local _updatable={}
local _drawable={}

_.update=function()
end

_.draw=function()
	for entity, drawable in pairs(_drawable) do
		drawable(entity)
	end
end

_.add=function(entity)
	table.insert(_entities, entity)
	
	local entity_load=entity.load
	if entity_load then
		entity_load()
	end

	local draw=entity.draw
	if draw then
		_drawable[entity]=draw
	end
	
	local update=entity.update
	if update then
		_updatable[entity]=update
	end
	
end




return _