local _={}

-- all registered, except services
local _all={}



-- k=1..max, v={entity,draw}
local _drawable={}
-- k=entity, v=draw function
local _uidrawable={}
local _scaleduidrawable={}

-- k=entity, v=upd function
local _updateable={}
local _slowUpdateable={}
local _ai={}
local _keyListeners={}

-- debug
_._all=_all
_._drawable=_drawable

-- read only please
_.getAll=function()
	return _all
end

_.getDrawable=function()
	return _drawable
end


_.getWorld=function(login)
	local result={}
	for k,entity in pairs(_all) do
		local dbgEntityInfo=Entity.toString(entity)
		if entity.isInWorld then
			if entity.entity=="Player" and entity.login==login then
				-- client responsible for its player, we dont send it
			else
				table.insert(result,entity)
			end
			
		end
	end
	
	return result
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
		if entity.entity=="BirchTree" then
			local a=1
		end
		
		
		register(entity)
	end
end

local addToCollision=function(entity)
--	log("addToCollision:"..Entity.toString(entity))
	-- local isInWorldDbg=entity.isInWorld
	if entity.w>0 and entity.h>0 and entity.isInWorld then
		Collision.add(entity)
	else
--		log("not square entity:"..entity.entity)
	end
end

local removeFromCollision=function(entity)
	Collision.remove(entity)
end


-- добавить в коллизии
-- вызвать activate()
-- подключить события
local activate=function(entity)
--	log("activating:"..Entity.toString(entity))
	
	if entity.entity=="Seed" then
		local a=1
	end
	
	
	local entityCode=_get(entity.entity)
	
	if entityCode.activate then
		entityCode.activate(entity)
	end
	
	
	if entity.isDrawable then
		
		
		table.insert(_drawable,{entity=entity,draw=entityCode.draw})
		-- _drawable[entity]=entityCode.draw
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
		
		local fnSlowUpdate=entityCode.slowUpdate
		if fnSlowUpdate~=nil then
			_slowUpdateable[entity]=fnSlowUpdate
		end
	end
	
	
	if entity.aiEnabled then
		_ai[entity]=entityCode.updateAi
	end
	
	if entityCode.keypressed~=nil then
		_keyListeners[entity]=entityCode.keypressed
	end
	
	
	entity.isActive=true
	
	if entity.isInWorld then
		addToCollision(entity)
	end
end

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

local deactivate=function(entity)
	log("deactivating:"..Entity.toString(entity))
	local entityCode=_get(entity.entity)
	
	if entityCode.deactivate then
		entityCode.deactivate(entity)
	end
	
	-- problem: entity.isDrawable was changed
	-- make setDrawable func? ok
	
	if entity.isDrawable then
		--_drawable[entity]=nil
		removeDrawable(entity,_drawable)
		-- table_removeByVal(_drawable,entityCode.draw)
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
	
	local fnSlowUpdate=entityCode.slowUpdate
	if fnSlowUpdate~=nil then
		local isRemoved=table_removeByVal(_slowUpdateable,fnSlowUpdate)
		assert(isRemoved)
	end
	

	if entity.aiEnabled then
		local isRemoved=table_removeByVal(_ai,entityCode.updateAi)
		if not isRemoved then
			local a=1
		end
		
		
		assert(isRemoved)
	end
	
	if entityCode.keypressed~=nil then
		_keyListeners[entity]=nil
	end
	
	entity.isActive=false
end


-- setActive is safer
_.deactivate=deactivate

_.isService=function(entity)
	return entity.id==nil
end

local isService=_.isService

_.isRegistered=function(entity)
	local key=Lume.find(_all,entity)
	local result=key~=nil
	return result
end

_.register=function(entity)
	log("registering:"..Entity.toString(entity))
	-- service entity created at runtime, and do not need to be serialized
	local isService=isService(entity)
	local isActive=not (entity.isActive==false) -- true or nil
	
	if not isService then
		if Config.isDebug then
			local alreadyRegistered,regged=Lume.find(_all,entity)
			if alreadyRegistered then
				log("error: attempt to register entity twice:"..Entity.toString(entity))
			end
			
			
		end
		
		
		table.insert(_all,entity)
	end
	
	
	if isActive then
		activate(entity)
	else
		
	end
end


_.delete=function(entityName,entityId,entityLogin)
	log("deleting entity:"..entityId.." n:"..entityName.." l:"..tostring(entityLogin))
	local entity=_.find(entityName,entityId,entityLogin)
	return _.deleteByEntity(entity)
end

-- удаляется только локально 
-- если надо везде - использовать (см пикап, или выход игрока)
-- nil entityLogin means local entity
_.deleteByEntity=function(entity)
	assert(entity)
	
	if entity.isActive then deactivate(entity) end
	
	local isRemoved=table_removeByVal(_all,entity)
	assert(isRemoved)
	
-- local only, remote processEven react to event	
--	local event=Event.new()
--	event.code="entity_remove"
--	event.entityName=entityName
--	event.entityId=entityId
--	event.entityLogin=entityLogin

	if entity.isInWorld then 
		Entity.removeFromWorld(entity)
	end
	

	return entity
end

_.unregister=_.delete

-- nil login means local entity (same login as current)
_.find=function(entityName,id,login)
	if login==nil then login=Session.login end
	
	for k,entity in pairs(_all) do
		if entity.entity==entityName and entity.id==id and entity.login==login then
			return entity
		end
	end
	
	return nil
end

_.findByRef=function(entityRef)
	return _.find(entityRef.entity,entityRef.id,entityRef.login)
end





local compareByY=function(info1,info2)
	local entity1=info1.entity
	local entity2=info2.entity
	if entity1.y>entity2.y then return false end
	if entity1.y<entity2.y then return true end
	return false
end

local updateYSort=function()
--	local testSort={} 
--	local e1={y=10}
--	local e2={y=2}
--	local e3={y=40}
	
	
--	testSort[e1]="e1"
--	testSort[e2]="e2"
--	testSort[e3]="e3"
	
--	local sorter=function(a, b)
--		return a.y > b.y 
--	end
--	local beforeSort=Inspect(testSort)
--	table.sort(testSort,sorter)
--	local afterSort=Inspect(testSort)
	
	
--	local beforeSort2=Inspect(_drawable)
	table.sort(_drawable,compareByY)
--	local afterSort2=Inspect(_drawable)
	
--	local a
end




_.draw=function()
		
	
-- bottom origin - later	
--		LG.draw(entity.sprite,entity.x,entity.y-entity.height)
	
	for k,info in ipairs(_drawable) do
		local entity=info.entity
--		log("draw:"..entity.entity.." at:"..xy(entity.x,entity.y))
		info.draw(entity)
	end
	
	local activeEntity=Session.selectedEntity
	if activeEntity~=nil then
		LG.rectangle('line',activeEntity.x-1,activeEntity.y-1,activeEntity.w+2,activeEntity.h+2)
	end
end


-- zoomed ui
_.drawUi=function()
	for entity,code in pairs(_uidrawable) do
		code(entity)
	end
end

-- 1x size ui
_.drawScaledUi=function()
	local test=Util.dump(_scaleduidrawable)
	for entity,code in pairs(_scaleduidrawable) do
		code(entity)
	end
end

_.setActive=function(entity, isActive)
	log("Entity.setActive:"..Entity.toString(entity)..":"..tostring(isActive))
	
	
	-- todo: easier, allow same state without warn
	-- assert(entity.isActive~=isActive)
	if entity.isActive==isActive then
		-- its ok now
		-- no its not
		-- баг на игре саженца - сущность уже активна, но не в мире,
		-- и поэтому не проходит activate а не помещается в мир
		log("setActive: entity have same active state:"..Entity.toString(entity))
		return
	end
	
	entity.isActive=isActive
	
	if isActive then
		if not Entity.isRegistered(entity) and not Entity.isService(entity) then
			--тут activate тоже происходит
			Entity.register(entity)
		else
			activate(entity)
		end
	else
		deactivate(entity)
	end

	
	
	
	
end


_.setDrawable=function(entity, isDrawable)
	if entity.isDrawable==isDrawable then
		-- todo: uncomment for optimizations
		--log("warn: entity have same active state")
		return
	end
	
	entity.isDrawable=isDrawable
	
	if isDrawable then
		local entityCode=_get(entity.entity)
		
		table.insert(_drawable,{entity=entity,draw=entityCode.draw})
	else
		removeDrawable(entity,_drawable)
	end
	
end

_.setSprite=function(entity,spriteName)
	entity.spriteName=spriteName
	
	local sprite=Img[spriteName]
	
	entity.w=sprite:getWidth()
	entity.h=sprite:getHeight()
	
	-- notify collision system?
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
	
	if Session.frame%30==0 then
		updateYSort()
	end
	
end

-- todo: механизм размазывания по фреймам

-- now every second.
_.slowUpdate=function()
		for entity,updateFunc in pairs(_slowUpdateable) do
		updateFunc(entity)
	end
end



_.keypressed=function(key,unicode)
	--local isProcessed=false
	
	-- todo: sort
	-- todo: locking
	for entity,fnPressed in pairs(_keyListeners) do
		local isProcessed=fnPressed(entity,key,unicode)
		if isProcessed then return true end
	end
	
	return false
end

-- any side
_.transferToServer=function(entities)
	if Session.isServer then
		_.acceptAtServer(entities)
		return
	end
	
	
	-- ни на что не влияет, просто для дебага
	for k,entity in pairs(entities) do
		entity.isTransferring=true
	end
	
	-- из ивентов можно мержить
	local event=Event.new()
	event.entities=entities
	event.code="transfer_to_server"
end

local getProto=function(entity,entityCode)
	local result=entityCode.new({isProto=true})
	return result
end


_.acceptAtServer=function(entities)
	
	local login=nil
	for k,entity in pairs(entities) do
		-- register
		if login==nil then
			login=entity.login
		end
		
		entity.prevId=entity.id
		
		local entityCode=Entity.get(entity.entity)
		local proto=getProto(entity,entityCode)
		if proto.aiEnabled then
			entity.aiEnabled=true
		end
		
		if entity.login~=Session.login then
			entity.id=Id.new(entity.entity)
			entity.login=Session.login
			Entity.register(entity)
		else
			if not Entity.isRegistered(entity) then
				Entity.register(entity)
			end
		end
	end
	
	assert(login~=nil)
	
	-- send back to entities_transferred
	
	local response={}
	response.cmd="entities_transferred"
	
	-- todo: лучше сделать у каждой сущности, но можно позже, пока что все с одного логина
	response.originalLogin=login
	response.entities=entities
	
	log("Entity.acceptAtServer. originalLogin:"..login.." new login:"..Session.login)
	
	Server.send(response)
end

_.debugPrint=function()
	log("Entity debug print start: -------[")
	log("All:")
	
	local toString=Entity.toString
	
	for k,v in pairs(_all) do
		log(toString(v))
	end
	
	log("Drawable:")
	for k,v in pairs(_drawable) do
		log(toString(v.entity))
	end
	
	log("Entity debug print end:   ]-------")
end

_.toString=function(entity)
	if entity==nil then return "nil" end
	local result=entity.entity.." id:"..tostring(entity.id)..
		" rm:"..tostring(entity.isRemote)..
		" a:"..tostring(entity.isActive)..
		" xywh:"..xywh(entity).." l:"..entity.login
	return result
end


--should be called after move to update collision sytem
_.onMoved=function(movedEntity)
--	log("Entity onMoved:"..Entity.toString(entity))
	
	if movedEntity.isInWorld then
		Collision.moved(movedEntity)
	end
	
	if movedEntity.mountedBy~=nil then
		local rider=Entity.findByRef(movedEntity.mountedBy)
		
		local riderX,riderY=_.getRiderPoint(movedEntity,rider)
		
		Entity.move(rider,riderX,riderY)
	end
	
	
end

_.getRiderPoint=function(mount, rider)
	local riderX=mount.x+mount.mountX-rider.riderX
	local riderY=mount.y+mount.mountY-rider.riderY
	
	return riderX,riderY 
end


-- локальное мгновенное перемещение сущности. 
-- если нужно плавное - 
_.move=function(entity,newX,newY)
	entity.x=newX
	entity.y=newY
	_.onMoved(entity)
end


_.smoothMove=function(entity,durationSec,x,y)
	log("start move:".._ets(entity))
	
	local entityLocals=Entity.getLocals(entity)
	entityLocals.isMoving=true
	
	local prevTween=entityLocals.moveTween
	if prevTween~=nil then
		log("cancel prev move")
		prevTween:stop()
	end
	
	local onComplete=function() 
		entityLocals.isMoving=false
		entityLocals.moveTween=nil
		log("end move:".._ets(entity))
	end
	
	local onUpdate=function() 
		Entity.onMoved(entity)
	end
	
	
	local tween=Flux.to(entity, durationSec, { x=x, y=y }):ease("quadout")
		:onupdate(onUpdate)
		:oncomplete(onComplete)
		
	entityLocals.moveTween=tween
end



_.getCenter=function(entity)
	if entity.x==nil then
		local a=1
	end
	
	
	local x=entity.x+(entity.w/2)
	local y=entity.y+(entity.h/2)
	
	return x,y
end

-- решить: можно сыграть это, поместив сущность без коллизии
-- котёл:
_.placeInWorld=function(entity)
	dbgCtxIn("Entity.placeInWorld")
	if entity.isInWorld then
		log("error: entity already in world:"..Entity.toString(entity))
	end
	
	
	entity.isInWorld=true
		-- was bug addToCollision in setActive->activate. непонятно уже.
		-- addToCollision(entity)
	_.setActive(entity,true)
	dbgCtxOut()
end

-- убрать из системы коллизий
_.removeFromWorld=function(entity)
	if entity.isInWorld then
		entity.isInWorld=false
		removeFromCollision(entity)
	else
		-- todo:uncomment for optimizing
		--log("warn: removeFromWorld: entity not in world")
	end
end

_.getCount=function()
	return #_all
end

-- использовать осторожно - удалять сущности, только у детачнутых
-- менять, т.к. нет механизма уведомления сервера о смене логина и ид
_.changeLogin=function(entity,login)
	
	
	assert(not entity.isActive)
	entity.login=login
	entity.isRemote=login==Session.login
	local oldId=entity.id
	entity.id=Id.new(entity.entity)
	
	log("changeLoginAndId:"..Entity.toString(entity).." new:"..login.." old id:"..oldId)
end

-- 1-time use item
_.usePlaceable=function(entity,x,y,isFromEditor)
	dbgCtxIn("Entity.usePlaceable")
		-- для move нужна коллизия, тут ее еще нет, нужно просто поставить координаты
		
	local adjustedX=x-entity.originX
	local adjustedY=y-entity.originY
		
	Entity.move(entity,adjustedX,adjustedY)
	
	if not isFromEditor then
		Player.removeItem(entity)
	end
	
	Entity.placeInWorld(entity)
	Entity.transferToServer({entity})
	dbgCtxOut()
end

	
_.notifyUpdated=function(entity)
	local event=Event.new()
	event.entities={entity}
	event.code="entities_updated"
	event.target="others"
end
	
_.updateValues=function(updatedEntity)
	log("Event.updateValues:"..Entity.toString(updatedEntity))
	-- респонз обновляет текущую сущность, ссылки 1 уровня остаются живые
	
	local originalEntity=Entity.find(updatedEntity.entity,updatedEntity.id,updatedEntity.login)
	assert(originalEntity)
	
	for k,field in pairs(updatedEntity) do
		originalEntity[k]=field
	end
end

_.canInteract=function(entity)
	if entity.isTransferring then
		-- log("cannot interact:"..pack(entity))
		return false
	end
	
	return true
end	

local canInteract=_.canInteract

_.canPickup=function(entity)
	if not canInteract(entity) then 
		return false
	end
	
	return entity.canPickup
end

_.canMount=function(actorEntity,candidateEntity)
	if not candidateEntity.isMountable then return false end
	
	if candidateEntity.mountedBy~=nil then
		log("already mounted by:")
		
		-- still can mount if player not present
		local rider=Entity.findByRef(candidateEntity.mountedBy)
		if rider~=nil then return false end
	end
	
	
	return true
end

-- light reference
-- reverse: findByRef
_.getReference=function(entity)
	local result={}
	
	result.id=entity.id
	result.login=entity.login
	result.entity=entity.entity
	
	return result
end


--local entity state. key: entityId, val: {}
local _entityLocals={}

_.getLocals=function(entity)
	local result=_entityLocals[entity]
	if result==nil then
		result={}
		--table.insert(_entityLocals, result)
		_entityLocals[entity]=result
	end
	
	return result
end


return _

