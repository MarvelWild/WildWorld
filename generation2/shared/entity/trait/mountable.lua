-- shared

local _={}

--[[ where rider should sit on this mount
duck typing:
rider.riderX
rider.riderY

mount.mountX
mount.mountY
]]--
_.get_rider_point=function(mount, rider)
	local riderX=mount.x+mount.mountX-rider.riderX
	local riderY=mount.y+mount.mountY-rider.riderY
	
--	log("get_rider_point calculation: riderX=mount.x+mount.mountX-rider.riderX"..
--		riderX.."="..mount.x.."+"..mount.mountX.."-"..rider.riderX
--		,"mount")
	
--	log("get_rider_point calculation: riderY=mount.y+mount.mountY-rider.riderY"..
--		riderY.."="..mount.y.."+"..mount.mountY.."-"..rider.riderY
--		,"mount")
	
	return riderX,riderY 
end

local _get_rider_point=_.get_rider_point

--[[
связать 2 сущности
подвинуть райдера в точку маунта

]]--
_.do_mount=function(rider,mount,is_mounting)
	log("shared mountable: do_toggle_mount start. rider:".._ets(rider)..
		" mount:".._ets(mount).." is_mounting:"..tostring(is_mounting), "mount")
	
	-- todo: make this 1 time on create
	rider.is_mountable=true
	mount.is_mountable=true
	-- todo: check mount.mounted_by for consistency too
	
	if not is_mounting then
		-- unmount
		local prev_mount_ref=rider.mounted_on
		if prev_mount_ref~=nil then
			rider.mounted_on=nil
			mount.mounted_by=nil
			
			log("mount references unset")
		else
			log("warn: was not mounted but received unmount")
		end
	else --mount
		if rider.mounted_on~=nil then
			log("warn: was mounted but received mount")
		else
			rider.mounted_on=_ref(mount)
			mount.mounted_by=_ref(rider)
			
			log("mount references set", "verbose")
			
			if rider==nil then
				local a=1
			end
			
			-- jump to seat
			log("mounting. mount:".._ets(mount), "mount")
			
			local riderX,riderY=_get_rider_point(mount,rider)
		
			-- hop on mount
			local duration=0.4
			-- _.move=function(actor,x,y,duration,force_this,ignore_foot)
			Movable.move(rider,riderX,riderY,duration,true,true)
		end
	end
end






-- вызывается по флагу is_mountable
_.destroy=function(entity)
	log("detach mountables from:".._ets(entity))
	local rider_ref=entity.mounted_by
	if rider_ref~=nil then
		local rider=_deref(rider_ref)
		entity.mounted_by=nil
		rider.mounted_on=nil
	end
	
	local mount_ref=entity.mounted_on
	if mount_ref~=nil then
		local mount=_deref(mount_ref)
		entity.mounted_on=nil
		mount.mounted_by=nil
	end
end

return _