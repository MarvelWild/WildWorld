-- entity manager. single instance.
-- single entity code in base_entity

local _={}

-- _.update=

-- key-index, value - draw - {entity,draw}
local _drawable={}
local _updatable={}
local _lateUpdatable={}
local _keyPressedListeners={}
local _mousePressedListeners={}
local _uiDraws={}
local _uiDrawsUnscaled={}

--добавить сущность в менеджер
_.add=function(entity)
	log('adding entity:'..Entity.toString(entity),'entity',true)
	
	-- entityCode is module with draw,update etc contolling current entity data/dto
	local entityCode=_.getCode(entity)
	
	if entityCode==nil then
		local a=1
	end
	
	local draw=entityCode.draw
	if draw~=nil then
		table.insert(_drawable,{entity=entity,draw=draw})
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
	
	local drawUnscaledUi=entityCode.drawUnscaledUi
	if drawUnscaledUi~=nil then
		_uiDrawsUnscaled[entity]=drawUnscaledUi
	end
	
	local keyPressed=entityCode.keyPressed
	if keyPressed~=nil then
		_keyPressedListeners[entity]=keyPressed
	end
	
	local mousePressed=entityCode.mousePressed
	if mousePressed~=nil then
		_mousePressedListeners[entity]=mousePressed
	end
end

-- drawables are array to make it sortable
local removeDrawable=function(entity,container)
	--local countBefore
	log("drawables before remove:"..#container)
	for k,info in ipairs(container) do
		if info.entity==entity then 
			table.remove(container,k)
			-- container[k]=nil wrong way (sort crash on nil)
			
			log("drawables after remove:"..#container)
			return
		end
	end
	
	local count=#container
	log("drawables after remove:"..count)
	
	if count>0 then
		log("error: removeDrawable failed. Entity was not in drawables:".._ets(entity))
	end
end

_.remove=function(entity)
	removeDrawable(entity,_drawable)
	_updatable[entity]=nil
	_lateUpdatable[entity]=nil
	_keyPressedListeners[entity]=nil
	_uiDraws[entity]=nil
	_uiDrawsUnscaled[entity]=nil
	_mousePressedListeners[entity]=nil
end

local compareByDrawLayer=function(info1,info2)
	local entity1=info1.entity
	local entity2=info2.entity
	if entity1.drawLayer>entity2.drawLayer then return false end
	if entity1.drawLayer<entity2.drawLayer then return true end
	return false
end

_.draw=function()
	-- todo: optimize
	table.sort(_drawable,compareByDrawLayer)
	
	for k,drawInfo in ipairs(_drawable) do
		--log("drawing:".._ets(drawInfo.entity))
		drawInfo.draw(drawInfo.entity)
		
	end
end

_.drawUi=function()
	for entity,draw in pairs(_uiDraws) do
		draw()
	end
end

_.drawUnscaledUi=function()
	for entity,draw in pairs(_uiDrawsUnscaled) do
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


_.keyPressed=function(key)
	for entity,listener in pairs(_keyPressedListeners) do
		listener(key)
	end
end

_.mousePressed=function(gameX,gameY,button,istouch)
	for entity,listener in pairs(_mousePressedListeners) do
		listener(gameX,gameY,button,istouch)
	end
end


_.toString=function(entity)
	if entity==nil then return "nil" end
	
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