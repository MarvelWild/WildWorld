-- server

local _={}


_.remove_from_hand=function(actor)
	
	local removable=_deref(actor.hand_slot)
	if not removable then 
		log("warn: remove_from_hand - no item")
		return
	end
	
	Db.remove(removable)
	actor.hand_slot=nil
end

	


_.do_pickup=function(actor,pickable)
	
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
	
	
	pickable.carried_by=_ref(actor)
	
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




_.do_drop=function(actor)
	-- drop
	local item=_deref(actor.hand_slot)
	Pin_service.unpin(item)
	actor.hand_slot=nil
	local item_x=item.x
	
	-- bug: если быстро поднимать - вещь ещё не в руке, а тут считается словно в руке
	local dy=actor.foot_y-actor.hand_y
	local item_y=item.y+dy
	Movable.smooth_move(item,0.3,item_x,item_y)
	
	local event=Event.new("drop")
	event.actor_ref=_ref(actor)
	event.slot_name="hand_slot"
	event.target="level"
	event.level=actor.level_name
	event.do_not_process_on_server=true
	event.dy=dy

	Event.process(event)	
end

return _