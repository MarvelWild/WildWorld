--[[ server part

	duck typing:
	rider.mounted_on - reference
	mount.mount_slots - {} -- see camen
]]--
local _={}

local _event=Pow.net.event

local _entity_equals=Entity.equals

-- server. entity interacts, decides to mount, now we here
-- send event, handled by do_toggle_mount
_.toggle_mount=function(rider,mount)
	-- todo: checks can mount
	
	if mount==nil then
		local a=1
	end
	
	local is_mounting=rider.mounted_on==nil
	
	local slot_id=nil
	local mount_slots=mount.mount_slots
	
	if is_mounting then
		local free_slot=nil
		-- todo: slot order
		for key, slot in pairs(mount_slots) do
			if slot.rider==nil then
				free_slot=slot
				slot_id=key
				break
			end
		end
		
		if free_slot==nil then
			log("mount already mounted")
			return
		end
	else -- unmounting
		-- найти ид слота
		-- и передать его в событие анмаунта
		
		for key, slot in pairs(mount_slots) do
			local rider_ref=slot.rider
			if _entity_equals(rider_ref,rider) then
				slot_id=key
				break
			end
		end
	end -- if is_mounting then
	
	
	-- goal: notify all it mounted (declarations updated: )
	
	-- so its generic entity update? 
	-- no, animation, and stuff, so it's a mount
	local do_mount_event=_event.new("do_mount")
	
	-- todo: doc why all
	do_mount_event.target="all"
	do_mount_event.is_mounting=is_mounting
	
	-- props updated in response, only directive to mount here
	do_mount_event.rider_ref=_ref(rider)
	do_mount_event.mount_ref=_ref(mount)
	
	do_mount_event.mount_slot_id=slot_id
	
	_event.process(do_mount_event)
	return true
end

_.is_mounting=function(rider)
	if rider==nil then
		local a=1
		return
	end
	
	local mount_ref=rider.mounted_on
	if mount_ref~=nil then
		if Movable.is_moving(rider) then
			return true
		end
		
	end
	
	return false
end

-- вызывается из конструктора сущности
_.init=function(entity)
	if not entity.mount_slots then log("error: no mount_slots:".._ets(entity)) end
	entity.is_mountable=true
end


return _