local _={}

local _entities={}
local _updatable={}


local _layers={}
for i=1,10 do 
	_layers[i]={}
end


-- wip
--drawable[layer]={}



_.update=function()
end

_.draw=function()
	for drawables_in_layer, drawables in ipairs(_layers) do
		for entity,drawable in pairs(drawables) do
			drawable(entity)
		end
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
		local layer=entity.layer
		local drawables_in_layer=_layers[layer]
		drawables_in_layer[entity]=draw
	end
	
	local update=entity.update
	if update then
		_updatable[entity]=update
	end
end


return _