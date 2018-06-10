local _={}

-- all registered, except services
local _all={}

-- k=entity, v=draw function
local _drawable={}
local _uidrawable={}
local _scaleduidrawable={}

local _updateable={}
local _ai={}

-- read only please
_.getAll=function()
	return _all
end


_.getLocal=function()
	local result={}
	for k,entity in pairs(_all) do
		if not entity.isRemote then
			table.insert(result,entity)
		end
	end
	
	return result
end

_.getSaving=function()
	return _.getLocal()
end



_.get=function(name)
	return _G[name]
end

local _get=_.get

_.registerWorld=function()
	-- reload not supported yet
	
	--we have editor items
	--assert(Lume.count(_all)==0)
	
	local world=World
	
	
	local register=_.register
	
	-- already in World.entities
	-- register(world.player)
	for k,entity in pairs(World.entities) do
		register(entity)
	end


	
end

local activate=function(entity)
	local entityCode=_get(entity.entity)
	
	if entityCode.activate then
		entityCode.activate(entity)
	end
	
	
	if entity.isDrawable then
		_drawable[entity]=entityCode.draw
	end
	
	if entity.isUiDrawable then
		_uidrawable[entity]=entityCode.drawUi
	end	
	
	if entity.isScaledUiDrawable then
		_scaleduidrawable[entity]=entityCode.drawScaledUi
	end
	
	if not entity.isRemote then
		local fnUpdate=entityCode.update
		if fnUpdate~=nil then
			_updateable[entity]=fnUpdate
		end
	end
	
	
	if entity.aiEnabled then
		_ai[entity]=entityCode.updateAi
	end
	
	entity.isActive=true
end

local deactivate=function(entity)
	local entityCode=_get(entity.entity)
	
	if entityCode.deactivate then
		entityCode.deactivate(entity)
	end
	
	-- problem: entity.isDrawable was changed
	-- make setDrawable func? ok
	
	if entity.isDrawable then
		table_removeByVal(_drawable,entityCode.draw)
	end
	
	if entity.isUiDrawable then
		table_removeByVal(_uidrawable,entityCode.drawUi)
	end
	
	if entity.isScaledUiDrawable then
		local isRemoved=table_removeByVal(_scaleduidrawable,entityCode.drawScaledUi)
	end
	
	local fnUpdate=entityCode.update
	if fnUpdate~=nil then
		local isRemoved=table_removeByVal(_updateable,fnUpdate)
		assert(isRemoved)
	end
	

	if entity.aiEnabled then
		local isRemoved=table_removeByVal(_ai,entityCode.updateAi)
		if not isRemoved then
			local a=1
		end
		
		
		assert(isRemoved)
	end
	
	entity.isActive=false
end



_.register=function(entity)
	
	-- service entity created at runtime, and do not need to be serialized
	local isService=entity.id==nil
	local isActive=not (entity.isActive==false) -- true or nil
	
	if not isService then
		-- was bug: entity.id could be the same for diff ent
		-- _all[entity.id]=entity
		table.insert(_all,entity)
		
	end
	
	
	if isActive then
		activate(entity)
	else
		
	end
end

-- alias: unregister
_.delete=function(entityName,entityId)
	-- untested
	local entity=_.find(entityName,entityId)
	assert(entity)
	
	if entity.isActive then deactivate(entity) end
	
	
	local isRemoved=table_removeByVal(_all,entity)
	assert(isRemoved)
end


_.find=function(entityName,id,login)
	if login==nil then login=Session.login end
	
	for k,v in pairs(_all) do
		if v.entity==entityName and v.id==id and v.login==login then
			return v
		end
	end
	
	return nil
end



local luaCompareByY=function(entity1,entity2)
	if entity1.y>entity2.y then return false end
	if entity1.y<entity2.y then return true end
	return false
end


_.draw=function()
	
	-- todo y sort
	
	-- table.sort(_drawable,luaCompareByY)
--	for i = 1, #_drawable do
--		local entity=_drawable[i]
----		log("draw entity:"..pack(entity))

--		LG.draw(entity.sprite,entity.x,entity.y-entity.height)
--	end
	
	for entity,code in pairs(_drawable) do
		code(entity)
	end
end

_.drawUi=function()
	for entity,code in pairs(_uidrawable) do
		code(entity)
	end
end

_.drawScaledUi=function()
	local test=Util.dump(_scaleduidrawable)
	for entity,code in pairs(_scaleduidrawable) do
		code(entity)
	end
end

_.setActive=function(entity, isActive)
	-- todo: easier, allow same state
	-- assert(entity.isActive~=isActive)
	if entity.isActive==isActive then
		log("warn: entity have same active state")
		return
	end
	
	entity.isActive=isActive
	
	if isActive then
		activate(entity)
	else
		deactivate(entity)
	end
	
	
end


_.setDrawable=function(entity, isDrawable)
	if entity.isDrawable==isDrawable then
		log("warn: entity have same active state")
		return
	end
	
	entity.isDrawable=isDrawable
	
	if isDrawable then
		local entityCode=_get(entity.entity)
		_drawable[entity]=entityCode.draw
	else
		_drawable[entity]=nil
	end
	
end


_.setAiEnabled=function(entity, aiEnabled)
	if entity.aiEnabled==aiEnabled then
		log("warn: entity have same aiEnabled state")
		return
	end
	
	
	
end


_.update=function(dt)
	for entity,updateFunc in pairs(_updateable) do
		updateFunc(entity,dt)
	end
	
	-- todo: update some ai's every frame, instead all at 200
	if Session.frame%200==0 then
		for entity,updateFunc in pairs(_ai) do
			updateFunc(entity,dt)
		end
	end
	
end



_.transferToServer=function(entities)
	for k,entity in pairs(entities) do
		entity.isTransferring=true
	end
	
	local event=Event.new()
	event.entities=entities
	event.code="transfer_to_server"
end

return _

--_.new=function()
	
--end


--return _



--[[ 1.0
-- container and manager for entities

local _={}

local _all={}

-- todo by layers, now all sorted by y
local _drawable={}
local _uiDrawable={}


local _inactive={}

--todo
local _keyListeners={}
--todo
local _mouseListeners={}

local compareByY=function(entity1,entity2)
	if entity1.y>entity2.y then return -1 end
	if entity1.y<entity2.y then return 1 end
	return 0
end

local luaCompareByY=function(entity1,entity2)
	if entity1.y>entity2.y then return false end
	if entity1.y<entity2.y then return true end
	return false
end

_.newProto=function()
	local result={}
	-- lower left point
	result.x=0
	
	-- affects: building process (see entitybuilder)
	result.type="entity"
	result.y=0
	result.width=0
	result.height=0
	-- use setSprite
	result.sprite=nil
	result.spriteName=nil
	
	result.iconSprite=nil
	result.iconSpriteName=nil
	result.isActive=nil
	
	-- fn attached, sprites loaded 
	-- todo: do not serialize
	result.isBuilt=false
	
	-- draw sort, not implemented
	result.layer=0
	
	return result
end

local newProto=_.newProto


_.new=function(fnInit,proto)
	if proto==nil then proto=newProto() end
	local result=proto
	
	result.id=Id.new("entity")
	
	if fnInit~=nil then fnInit(result) end
	_.register(result)
	
	return result
end

-- todo: runtime id for components
--local componentId=0



-- компонент это сущность без ид

-- для загруженныех сущностей, уже имеющих ид (не созданных entity.new)
-- единая точка приёма сущностей
_.register=function(entity)
	
	if not entity.isBuilt then
		EntityBuilder.build(entity)
	end
	
	
	table.insert(_all,entity)
	
	local isActive=entity.isActive
	if isActive==nil then isActive=true end
	_.setActive(entity,isActive)
end


_.setSprite=function(entity,name)
	entity.spriteName=name
	entity.sprite=Img[name]
	entity.width=entity.sprite:getWidth()
	entity.height=entity.sprite:getHeight()
end


local activateEntity=function(entity)
	if entity.drawUi~=nil then
		table.insert(_uiDrawable,entity)
	end
	
	if entity.draw~=nil then
		table.insert(_drawable,entity)
	end
	
	
end

local deactivateEntity=function(entity)
	table_removeByVal(_uiDrawable,entity)
	table_removeByVal(_drawable,entity)
end


_.setActive=function(entity,isActive)
	-- единая точка включения сущностей, отвечает за списки _uiDrawable
--	if entity.isActive==isActive then
--		log("warn: entity already active")
--		return
--	end
	
	entity.isActive=isActive
	if isActive then
		activateEntity(entity)
	else -- not active
		deactivateEntity(entity)
	end
end


_.update=function()
	-- todo: update all entities at once
	
	
	-- нужна пересортировка, т.к. y меняется
	--sortedByY:Sort()
end

_.draw=function()
	--opt:sort not every frame,drawable only
	table.sort(_drawable,luaCompareByY)
	for i = 1, #_drawable do
		local entity=_drawable[i]
--		log("draw entity:"..pack(entity))

		LG.draw(entity.sprite,entity.x,entity.y-entity.height)
	end
end

_.drawUi=function()
	for k,v in pairs(_uiDrawable) do
		v.drawUi()
	end
	
end

_.delete=function(entity)
	-- implement if needed
end

_.unpack=function(str)
	local result=deserialize(str)
	
	result.isBuilt=false
	
	return result
end

_.pack=function(entity)
	local prevIsBuild=entity.isBuilt
	entity.isBuilt=nil
	local result=serialize(entity)
	entity.isBuilt=prevIsBuild
	
	return result
end



return _
]]--