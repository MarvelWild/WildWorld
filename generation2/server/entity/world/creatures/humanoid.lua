-- server
local _={}

_.entity_name="humanoid"

local build_animation=function()
	local result={}
	
	local frames_walk={}
	result.walk=frames_walk
	
	local frame1={}
	frame1.sprite_name="player_7_walk_1"
	frame1.duration=30
	
	local frame2={}
	frame2.sprite_name="player_7_walk_2"
	frame2.duration=30
	
	
	table.insert(frames_walk,frame1)
	table.insert(frames_walk,frame2)
	
	result.idle=
	{
		{
			sprite_name="player_7",
			duration=nil
		}
	}
	
	return result
end



_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.x=0
	result.y=0
	
	result.name='Joe'
	result.level_name='start'
	
	result.foot_x=7
	result.foot_y=15
	
	result.hand_x=10
	result.hand_y=7
		
		
	result.hand_x_2=8
	result.hand_y_2=9
	
	
	
	-- collision sqquare start
	result.collisionX=3
	result.collisionY=0
	
	-- todo: collision end
	
	
	-- used for collisions
	result.w=9
	result.h=16
	
	result.riderX=7
	result.riderY=11
	
	result.hp=10
	result.hp_max=10
	
	result.energy=100
	result.energy_max=100
	
	-- ref? to pinned item
	result.hand_slot=nil
	result.hand_slot_2=nil
	
	
	
	result.sprite="player_7"
--	if _rnd(0,10)>5 then result.sprite="girl" end
	
	
	-- todo: presets
	if result.sprite=="player_7" then
		result.animation=build_animation()
	end
	
	
	
	
	BaseEntity.init_bounds_from_sprite(result)

	
	return result
end







--local take_damage=function(player)
--	-- todo detect damage source
	
--	local collsions=CollisionService.getEntityCollisions(player)
--	for k,entity in pairs(collsions) do
--		log("collision:".._ets(entity))
--		-- todo
		
--	end
	
	
--end


--_.update=function(dt,player)
----	take_damage(player)
--end


-- no checks
local do_pickup=function(actor,pickable)
	
	-- todo: same code on client pickup handler
	local hand_x
	local hand_y
	local slot_number
	
	if actor.hand_slot==nil then
		hand_x=actor.hand_x
		hand_y=actor.hand_y
		actor.hand_slot=_ref(pickable)
		slot_number=1
	elseif actor.hand_slot_2==nil then
		hand_x=actor.hand_x_2
		hand_y=actor.hand_y_2
		actor.hand_slot_2=_ref(pickable)
		slot_number=2
	else
		-- no free slot
		return
	end
	
	Pin_service.pin(actor,pickable,hand_x,hand_y,pickable.origin_x,pickable.origin_y)
	
	-- todo: pin on load. now it does drop, but item not pinned
	
	-- emit event to pin on level on clients
	local event=Event.new("pickup")
	event.actor_ref=_ref(actor)
	event.pick_ref=_ref(pickable)
	event.target="level"
	event.level=actor.level_name
	event.slot_number=slot_number
	event.do_not_process_on_server=true
	
	Event.process(event)
	return true
end


local try_pickup=function(actor,entity)
	log("try_pickup:".._ets(actor).." : ".._ets(entity))
	-- todo: generic pickable
	
	if entity.is_item then
		local result=do_pickup(actor,entity)
		if result then return true end
		
	end
	
end


-- todo: player получать из entity как управляющую ей сущность
_.interact=function(entity,target,player)
	local target_code=Entity.get_code(target)
	
	local interact=target_code.interact
	if interact~=nil and interact~=_.interact then
		return interact(entity,target,player)
	else
		return try_pickup(entity,target)
	end
end

return _