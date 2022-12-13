local _={}

local _updatable={}
local _mouse_pressed_listeners={}


local _layers={}
for i=1,10 do 
	_layers[i]={}
end

_.update=function()
	for entity,update in pairs(_updatable) do
		update(entity)
	end
end

_.draw=function()
	for drawables_in_layer, drawables in ipairs(_layers) do
		for entity,drawable in pairs(drawables) do
			drawable(entity)
		end
	end
end

_.mouse_pressed=function(x,y,button)
	-- todo: order
	for i,listener in pairs(_mouse_pressed_listeners) do
		listener(x,y,button)
	end
end


_.add=function(code,entity)
	
	local entity_load=code.load
	if entity_load then
		entity_load()
	end

	local draw=code.draw
	if draw then
		local layer=entity.layer or 10
		local drawables_in_layer=_layers[layer]
		drawables_in_layer[entity]=draw
	end
	
	local update=code.update
	if update then
		_updatable[entity]=update
	end
	
	local mouse_pressed=code.mouse_pressed
	if mouse_pressed then
		_mouse_pressed_listeners[entity]=mouse_pressed
	end
end


return _