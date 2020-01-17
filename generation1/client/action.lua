-- global ClientAction
local _={}

--[[

]]--

-- response: pickup_ok
_.pickup=function(entity)
	log("picking up (create event):"..Entity.toString(entity))
	
	local event=Event.new()
	event.code="pickup"
	event.entityName=entity.entity
	event.entityId=entity.id
	event.entityLogin=entity.login
	event.target="server"
end


-- инициация цепочки
local doMount=function(actorEntity,target)
	log("doMount:"..Entity.toString(actorEntity).." on:"..Entity.toString(target))
	
	local event=Event.new()
	event.code="mount"
	
	event.actorEntityName=actorEntity.entity
	event.actorEntityId=actorEntity.id
	event.actorEntityLogin=actorEntity.login
	
	if target~=nil then
		event.targetEntityName=target.entity
		event.targetEntityId=target.id
		event.targetEntityLogin=target.login
	end
	
	
	event.target="server"
	-- handlers: event\mount.lua
	-- event\mount_ok.lua
end




_.toggleMount=function(actorEntity)
	log("toggleMount start")
	-- по аналогии с пикапом - шлём команду на сервер, по подтверждении - сели.
	
	if actorEntity.mountedOn~=nil then
		doMount(actorEntity,nil)
		return
	end
	
	
	local extraRange=10
	local doubleRange=extraRange+extraRange
	local x=actorEntity.x-extraRange
	local y=actorEntity.y-extraRange
	local w=actorEntity.w+doubleRange
	local h=actorEntity.h+doubleRange
	
	local candidateEntities=Collision.getAtRect(x,y,w,h)
	
	if not candidateEntities then
		log("Noone to mount on")
		return
	end
	
	-- todo: mount another player: ask first
	
	local toMount
	
	log("mount candidates:"..Inspect(candidateEntities))
	
	for k,candidateEntity in pairs(candidateEntities) do
		if Entity.canMount(actorEntity,candidateEntity) then
			toMount=candidateEntity
			break
		else
			log("cannot mount:".._ets(actorEntity).." on:".._ets(candidateEntity))
		end
	end
	
	if toMount~=nil then
		doMount(actorEntity,toMount)
	else
		log("noone to mount")
	end
end





_.deleteSelected=function()
	log("ClientAction.deleteSelected")
	
	local selected=Session.selectedEntity
	if selected==nil then
		log("no selection")
		return
	end
	
	if selected.entity=="Player" then
		log("cannot delete player")
		return
	end
	
	
	local event=Event.new()
	event.code="entity_delete"
	event.entityName=selected.entity
	event.entityId=selected.id
	event.entityLogin=selected.login
	event.target="server" 
	Session.selectedEntity=nil
end



_.move=function(actor,x,y)
	
	local nextX,nextY
	local movingEntityRef
	if actor.mountedOn~=nil then
		movingEntityRef=actor.mountedOn
		
		local mount=Entity.findByRef(movingEntityRef)
		nextX=x-mount.footX
		nextY=y-mount.footY
		
		
		local mountStanding=Standing.get(actor,mount)
		if mountStanding<0 then
			nextX=nextX+Lume.random(-100,100)
			nextY=nextY+Lume.random(-100,100)
		end
		
		
		
		
	else
		movingEntityRef=Entity.getReference(actor)
		nextX=x-actor.footX
		nextY=y-actor.footY
	end
	
	
	
	local moveEvent=Event.new()
	moveEvent.code="move"
	
	moveEvent.x=nextX
	moveEvent.y=nextY
	moveEvent.duration=2
	
	moveEvent.entityRef=movingEntityRef

	-- then: Entity.smoothMove
end

_.setWorld=function(worldName)
	
	log("requesting:setWorld:"..worldName)
	
	local player=CurrentPlayer
	assert(player)
	
	local event=Event.new()
	event.code="set_world"
	event.worldName=worldName
	event.actorRef=Entity.getReference(player)
	event.target="server"
end


return _