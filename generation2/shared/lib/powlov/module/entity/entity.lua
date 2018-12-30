-- entity manager. single instance.

local _={}


-- _.update=
local _drawable={}
local _updatable={}

--добавить сущность в менеджер
_.add=function(entity)
	local entityCode=nil
	if entity.isService then
		entityCode=entity
	end
	
	local draw=entityCode.draw
	if draw~=nil then
		_drawable[entity]=draw
	end
	
	local update=entityCode.update
	if update~=nil then
		_updatable[entity]=update
	end
	
	
end

_.remove=function(entity)
	_drawable[entity]=nil
	_updatable[entity]=nil
end

_.draw=function()
	for entity,drawProc in pairs(_drawable) do
		drawProc()
	end
end

_.update=function(dt)
	for entity,updateProc in pairs(_updatable) do
		updateProc(dt)
	end
end






return _