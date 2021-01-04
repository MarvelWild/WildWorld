--[[ server part

	duck typing:
	rider.mounted_on - reference
	mount.mounted_by - reference
]]--
local _={}

local _event=Pow.net.event

-- server. entity interacts, decides to mount, now we here
-- send event, handled by do_toggle_mount
_.toggle_mount=function(rider,mount)
	-- todo: checks can mount
	
	if mount==nil then
		local a=1
	end
	
	
	local is_mounting=rider.mounted_on==nil
	
	if is_mounting then
		if mount.mounted_by~=nil then
			log("mount already mounted")
			return
		end
		
	end
	
	-- goal: notify all it mounted (declarations updated: )
	
	-- so its generic entity update? 
	-- no, animation, and stuff, so it's a mount
	local do_mount_event=_event.new("do_mount")
	do_mount_event.target="all"
	do_mount_event.is_mounting=is_mounting
	
	-- props updated in response, only directive to mount here
	do_mount_event.rider_ref=_ref(rider)
	do_mount_event.mount_ref=_ref(mount)
	
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


_.init=function(entity)
	if not entity.mountX then log("error: no mountX:".._ets(entity)) end
	if not entity.mountY then log("error: no mountY:".._ets(entity)) end
end


return _