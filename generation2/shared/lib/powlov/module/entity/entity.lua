-- entity manager. single instance.
-- single entity code in base_entity

local _={}

-- _.update=

-- key-index, value - draw - {entity,draw}
local _drawable={}
local _updatable={}
local _lateUpdatable={}

-- ai should not update every turn, or update by parts
local _aiUpdatable={}

-- entity-fnSim(entity)
local _simulations={}

local _keyPressedListeners={}
local _mousePressedListeners={}
local _uiDraws={}
local _uiDrawsUnscaled={}

--добавить сущность в менеджер
-- use Db.add
_.add=function(entity)
	log('adding entity:'..Entity.toString(entity),'entity',true)
	
	-- entityCode is module with draw,update etc contolling current entity data/dto
	local entityCode=_.getCode(entity)
	
	if entityCode==nil or entity.entityName=="panther" then
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
	
	local updateAi=entityCode.updateAi
	if updateAi~=nil then
		_aiUpdatable[entity]=updateAi
	end
	
	local simulation=entityCode.updateSimulation
	if simulation~=nil then
		_simulations[entity]=simulation
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
	_aiUpdatable[entity]=nil
	_simulations[entity]=nil
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

local _aiKey=nil
local function getNextAiFn()
	
	local entity,fnUpdate=next(_aiUpdatable, _aiKey)
	_aiKey=entity
--	local result=_aiUpdatable[_aiIndex]
--	_aiIndex=_aiIndex+1

	return fnUpdate,entity
end

local _simulationKey=nil
local function getNextSimulationFn()
	local entity,fn=next(_simulations, _simulationKey)
	_simulationKey=entity
	return fn,entity
end



local _isSimulationOrAi=false

_.update=function(dt)
	for entity,updateProc in pairs(_updatable) do
		updateProc(dt)
	end
	
	local frameNumber=Pow.getFrame()
	if frameNumber%60==0 then
		-- log("update ai")
--		for entity,updateAiProc in pairs(_aiUpdatable) do
--			updateAiProc(entity,dt)
--		end
		_isSimulationOrAi=not _isSimulationOrAi

		if _isSimulationOrAi then
			local fnNextAi,entity=getNextAiFn()
			if fnNextAi~=nil then
				fnNextAi(entity)
			end
		else
			local fnNextSimulation,entity=getNextSimulationFn()
			if fnNextSimulation~=nil then
				fnNextSimulation(entity)
			end
		end
		
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

-- 
_.mousePressed=function(gameX,gameY,button,istouch)
	for entity,listener in pairs(_mousePressedListeners) do
		listener(gameX,gameY,button,istouch)
	end
end


_.toString=function(entity)
	if entity==nil then return "nil" end
	
	local result=entity.entityName
	if entity.id~=nil then
		result=result.." id:"..tostring(entity.id)..' xy:'..
			tostring(entity.x)..','..tostring(entity.y)
	end
	
	return result
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
		local result = _.getCodeByName(entity.entityName)
		return result
	end
end

_.getCodeByName=function(entityName)
		local result=_entityCode[entityName]
		if (result==nil) then
			log("error: entity has no code:"..entityName)
		end
		
		return result 
end


return _