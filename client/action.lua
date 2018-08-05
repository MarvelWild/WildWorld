-- global ClientAction
local _={}

--[[

]]--
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
	
	event.targetEntityName=target.entity
	event.targetEntityId=target.id
	event.targetEntityLogin=target.login
	
	
	event.target="server"
end


_.mount=function(actorEntity)
	log("Mount start")
	-- по аналогии с пикапом - шлём команду на сервер, по подтверждении - сели.
	
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
	local moveEvent=Event.new()
	moveEvent.code="move"
	moveEvent.x=x-7
	moveEvent.y=y+1-actor.h
	moveEvent.duration=2
	
	moveEvent.entity=actor.entity
	moveEvent.entityId=actor.id
	
	-- todo: move to entityRef, no login here, check this
end

return _