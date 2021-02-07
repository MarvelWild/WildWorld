-- shared

local _={}

--[[ where rider should sit on this mount
duck typing:
rider.riderX
rider.riderY

mount.mount_slots
]]--
_.get_rider_point=function(mount, rider,slot)
	local rider_x=mount.x+slot.x-rider.riderX
	local rider_y=mount.y+slot.y-rider.riderY
	
	return rider_x,rider_y
end

local _get_rider_point=_.get_rider_point

--[[
связать 2 сущности
подвинуть райдера в точку маунта

]]--

_.do_mount=function(rider,mount,is_mounting,slot_id)
	log("shared mountable: do_toggle_mount start. rider:".._ets(rider)..
		" mount:".._ets(mount).." is_mounting:"..tostring(is_mounting), "mount")

	-- todo: make this 1 time on create
	rider.is_mountable=true
	mount.is_mountable=true
	
	local slot=mount.mount_slots[slot_id]
	
	if slot==nil then
		log("debug this")
	end
	
	
	if not is_mounting then
		-- unmount
		local prev_mount_ref=rider.mounted_on
		if prev_mount_ref~=nil then
			rider.mounted_on=nil
			
			slot.rider=nil
			
			log("mount references unset")
		else
			log("warn: was not mounted but received unmount")
		end
	else --mount
		if rider.mounted_on~=nil then
			log("warn: was mounted but received mount")
		else
			rider.mounted_on=_ref(mount)
			slot.rider=_ref(rider)
			
			log("mount references set mounted_on:"..serialize(rider.mounted_on), "verbose")
			
--			if rider==nil then
--			end
			
			-- jump to seat
			log("mounting. mount:".._ets(mount), "mount")
			
			
			local riderX,riderY=_get_rider_point(mount,rider,slot)
		
			-- hop on mount
			local duration=0.4

			-- _.move=function(actor,x,y,duration,force_this,ignore_foot)
			Movable.move(rider,riderX,riderY,duration,true,true)
		end
	end
end

-- вызывается по флагу is_mountable
_.destroy=function(entity_destroying)
	log("detach mountables from:".._ets(entity_destroying))
	
	-- удаляется маунт
	local mount_slots=entity_destroying.mount_slots
	if mount_slots~=nil then
		for k,slot in pairs(mount_slots) do
			local rider_ref=slot.rider
			local rider=_deref(rider_ref)
			rider.mounted_on=nil
		end
	end
	
	-- удаляется наездник
	local mount_ref=entity_destroying.mounted_on
	if mount_ref~=nil then
		local mount=_deref(mount_ref)
		mount_slots=mount.mount_slots
		
		if mount_slots~=nil then
			for k,slot in pairs(mount_slots) do
				local rider_ref=slot.rider
				if Entity.equals(rider_ref,entity_destroying) then
					slot.rider=nil
					break
				end
			end
		end
	end

end


_.is_mounted=function(mount)
	local slots=mount.mount_slots
	if slots==nil then return end
	
	for k,slot in pairs(slots) do
		if slot.rider~=nil then return true end
	end
	
	return false
end


return _