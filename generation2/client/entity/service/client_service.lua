-- global 
-- game specific network client
local _=BaseEntity.new("client_service",true)

local _client=Pow.client

local _event=Pow.net.event

local startGameForPlayer=function(player)
	local event=_event.new("game_start")
	
	
	event.playerId=player.id
	GameState.playerId=player.id
	event.target="server"
	
	-- response: full_state
	_event.process(event)
end

	

local afterPlayerCreated=function(response)
	-- start as player
	
		--[[
		response example: 
		{
			code = "create_player_response", 
			entity = "Event",
			id = 9,
			player = {
				entity = "player",
				id = 9, name = "mw"
			} 
		, target = "login",
		targetLogin = "c1"
		}
		]]--
	
	log('afterPlayerCreated', "verbose")
	
	local player=response.player
	startGameForPlayer(player)
	-- response is generic : onStateReceived
end

local unload_state=function()
	Entity.unload_state()
end


-- прилетает новый левел. 
local onStateReceived=function(response)
	log('onStateReceived','verbose')
	
	unload_state()
	
	-- state = {level = {bg = "main.png"} --[[table: 0x0f49dd38]], player = {entity = "player", id = 21, level = "start", name = "mw"} --[[table: 0x0f4510a8]]}
	local state=response.state
	local level=state.level
	GameState.level=level
	GameState.set(state)
	
	local sprite_name=level.level.bg
	
	local level_sprite=Img.get("level/"..sprite_name)
	local level_w=level_sprite:getWidth()
	local level_h=level_sprite:getHeight()
	
	Pow.cam:setWorld(0,0,level_w,level_h)
end

local doMove=function(event)
	
	-- local actor=Db.getByRef(event.actorRef)
	local actor=GameState.findEntity(event.actorRef)
	if actor==nil then
		log("warn: move no actor")
	end
	
	Movable.move(actor,event.x,event.y,event.duration)
end

local onEntityRemoved=function(event)
	--[[ event example:
	{
		code = "entity_removed", entity_name = "Event", entityRef = 
			{entity_name = "player", id = 11}  
		id = 42, level = "start", target = "level"}	
	]]--
--	log("onEntityRemoved:"..Pow.inspect(event))
	

	GameState.removeEntity(event.entityRef)
end



-- response to list_players
local onPlayersListed=function(event)
	log("onPlayersListed")
	local players=event.players
	-- todo: select by player
	
	local selectedPlayer=Pow.lume.first(players)
	if selectedPlayer==nil then
			local event=_event.new("create_player")
			event.player_name="mw"
			event.target="server"
			_event.process(event)
	else
		startGameForPlayer(selectedPlayer)
	end
	
end

local onEntityAdded=function(event)
	--log("onEntityAdded start")
	if GameState.level==nil then
		log("no level yet")
		return
	end
	
	
	local entities=event.entities
	for k,entity in pairs(entities) do
--		if entity.entity_name=="player" then
--		end
		
		if GameState.level.level_name~=entity.level_name then
			-- сейчас при проходе в портал добавляется новый игрок на новом уровне:
			--  сервер уже знает что игрок на новом уровне, а клиент ещё нет.
			-- log("todo: do not send event like this")
		else
			log("onEntityAdded:".._ets(entity))
			GameState.addEntity(entity)
		end
	end
end


local on_entity_updated=function(event)
	---todo: checks
	
	local entity=event.entity
	GameState.update_entity(entity)
end


local do_mount=function(event)
	-- paste from server
	log("client_service.do_mount start:"..Inspect(event))
	
	local rider_ref=event.rider_ref
	local mount_ref=event.mount_ref
	
	local rider=_deref(rider_ref)
	local mount=_deref(mount_ref)
	
	Mountable.do_mount(rider,mount,event.is_mounting)
end


local do_grow=function(event)
--	log("client_service.do_grow start")
	
	--[[
event sample	
{
level="start",
target="level",
code="do_grow",
id=2787,
entity={
        entity_name="tree",
        level_name="start",
        id=27
},
entity_name="Event",
sprite="birch_tree_1"
}	
	]]--

	local entity=_deref(event.entity)
	Entity.set_sprite(entity,event.sprite)
end

local pickup=function(event)
	log("client_service.pickup start:"..Inspect(event))
	
	local actor=_deref(event.actor_ref)
	
	local slot_number=event.slot_number
	local item_ref=event.pick_ref
	local entity=_deref(item_ref)
	
	if slot_number==1 then
		actor.hand_slot=item_ref
		Pin_service.pin(actor,entity,actor.hand_x,actor.hand_y,entity.origin_x,entity.origin_y)
	elseif slot_number==2 then
		actor.hand_slot_2=item_ref
		Pin_service.pin(actor,entity,actor.hand_x_2,actor.hand_y_2,entity.origin_x,entity.origin_y)
	else
		log("error: unknown slot")
	end
	
	
end

local drop=function(event)
	log("client_service.drop:"..Inspect(event))
	
	local actor=_deref(event.actor_ref)
	local slot_name=event.slot_name
	local item_ref=actor[slot_name]
	actor[slot_name]=nil
	
	local item=_deref(item_ref)
	
	-- todo: extract shared code / merge dup
	Pin_service.unpin(item)
	
	local item_x=item.x
	local dy=event.dy
	local item_y=item.y+dy
	Movable.smooth_move(item,0.3,item_x,item_y)
	
--	local item_ref=event.pick_ref
--	local entity=_deref(item_ref)
	
--	actor.hand_slot=item_ref
	
--	Pin_service.pin(actor,entity,actor.hand_x,actor.hand_y,entity.origin_x,entity.origin_y)
end

local craft_list=function(event)
	-- wip: show craft list
	local a=1
	local craftables=event.craftables
	
	CraftList.set(craftables)
	Entity.add(CraftList)
	
	-- wip: ui to pick from choices
	
	
	
end


-- 
local afterLogin=function(response)
	log('after login:'..Pow.pack(response), "net")
	
	-- todo: move to pow
	Pow.net.state.login=response.login
	love.window.setTitle(love.window.getTitle().." l:"..response.login)
	
	_event.add_handler("create_player_response", afterPlayerCreated)
	_event.add_handler("full_state", onStateReceived)
	_event.add_handler("move", doMove)
	_event.add_handler("entity_removed", onEntityRemoved)
	_event.add_handler("entity_added", onEntityAdded)
	_event.add_handler("entity_updated", on_entity_updated)
	_event.add_handler("do_mount", do_mount)
	_event.add_handler("do_grow", do_grow)
	_event.add_handler("pickup", pickup)
	_event.add_handler("drop", drop)
	_event.add_handler("craft_list", craft_list)
	
	log("added handler of create_player_response",'event')
	-- todo: remove handler on completion
	-- generic way? single response
	
	local event=_event.new("list_players")
	event.target="server"
	_event.process(event,onPlayersListed)
end


local login=function()
	log('login start','verbose')
	-- todo: get this from user
	local login=Pow.arg.get("login=", "defaultLogin")
	
		local data={
			cmd="login",
			login=login,
		}
		
		
	_client.send(data,afterLogin)
	
end

local registerGenericCode=function(entity)
	local entity_name=entity.entity_name
	
	local code=Entity.get_code(entity)
	if code~=nil then return end
	
	code=Generic
	
	log('Registering generic entity:'..entity_name)
	Entity.addCode(entity_name,code)
end


_.start=function()
	Entity.beforeAdd=registerGenericCode
	
	local isConnected=_client.connect(ConfigService.serverHost, ConfigService.port)
	if isConnected then
		login()
	else
		log("error:cannot connect to"..ConfigService.serverHost..":"..ConfigService.port)
	end
	
end

_.update=function(dt)
	_client:update(dt)
end

-- send move intention to server
-- game coordinates
_.move=function(x,y)
	-- todo: canMove checks
	local event=_event.new("intent_move")
	event.target="server"
	
	event.x=x
	event.y=y
	_event.process(event)
end




_.logoff=function()
	
end

	

_.defaultAction=function()
	local event=_event.new("default_action")
	event.target="server"
	_event.process(event)
end

return _