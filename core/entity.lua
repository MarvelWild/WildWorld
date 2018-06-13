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



-- client side
_.transferToServer=function(entities)
	for k,entity in pairs(entities) do
		entity.isTransferring=true
	end
	
	-- из ивентов можно мержить
	local event=Event.new()
	event.entities=entities
	event.code="transfer_to_server"
end

_.acceptAtServer=function(entities)
	log("Entity.acceptAtServer")
	local login=nil
	for k,entity in pairs(entities) do
		-- register
		if login==nil then
			login=entity.login
		end
		
		entity.login=Session.login

		entity.prevId=entity.id
		entity.id=Id.new(entity.entity)
		
		Entity.register(entity)
	end
	
	assert(login~=nil)
	
	-- send back to entities_transferred
	
	local response={}
	response.cmd="entities_transferred"
	
	-- лучше сделать у каждой сущности, но можно позже, пока что все с одного логина
	response.originalLogin=login
	response.entities=entities
	
	Server.send(response)
end


return _
