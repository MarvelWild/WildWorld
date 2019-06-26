-- entity manager. single instance.

local _={}

-- wip: processing order


-- _.update=
local _drawable={}
local _updatable={}
local _lateUpdatable={}
local _uiDraws={}

--добавить сущность в менеджер
_.add=function(entity)
	log('adding entity:'..Entity.toString(entity),'entity',true)
	
	-- entityCode is module with draw,update etc contolling current entity data/dto
	local entityCode=_.getCode(entity)
	
	local draw=entityCode.draw
	if draw~=nil then
		_drawable[entity]=draw
	end
	
	local update=entityCode.update
	if update~=nil then
		_updatable[entity]=update
	end
	
	local lateUpdate=entityCode.lateUpdate
	if lateUpdate~=nil then
		_lateUpdatable[entity]=lateUpdate
	end
	
	local drawUi=entityCode.drawUi
	if drawUi~=nil then
		_uiDraws[entity]=drawUi
	end
end

_.remove=function(entity)
	_drawable[entity]=nil
	_updatable[entity]=nil
	_lateUpdatable[entity]=nil
end

_.draw=function()
	
	-- wip: sort by z
	for entity,drawProc in pairs(_drawable) do
		drawProc(entity)
	end
end

_.drawUi=function()
	for entity,draw in pairs(_uiDraws) do
		draw()
	end
end

_.update=function(dt)
	for entity,updateProc in pairs(_updatable) do
		updateProc(dt)
	end
end


_.lateUpdate=function(dt)
	for entity,updateProc in pairs(_lateUpdatable) do
		updateProc(dt)
	end	
end



_.toString=function(entity)
	if entity==nil then return "nil" end
	
	if (entity.entityName==nil) then
		local a=1
	end
	
	
	return entity.entityName.." id:"..tostring(entity.id)..' xy:'..tostring(entity.x)..','..tostring(entity.y)
end

local _entityCode={}

-- register code that corresponds to data object
_.addCode=function(entityName,code)
	_entityCode[entityName]=code
end


-- description of code functions:
-- draw/upd/etc code for entity data/dto
_.getCode=function(entity)
	if entity.isService then
		-- service does not separate data, everything is a single module
		return entity
	else
		-- how we bind code and data? in _entityCode
		local result = _entityCode[entity.entityName]
		if (result==nil) then
			log("error: entity has no code:"..entity.entityName)
		end
		
		return result 
	end
end

return _