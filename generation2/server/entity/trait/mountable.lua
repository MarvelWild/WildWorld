--[[

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
	
	local is_mounting=rider.mounted_on==nil
	
	-- todo goal: notify all it mounted (declarations updated: )
	
	-- so its generic entity update? 
	-- no, animation, and stuff, so it's a mount
	local do_mount_event=_event.new("do_mount")
	do_mount_event.target="all"
	
	-- props updated in response, only directive to mount here
	do_mount_event.rider_ref=_ref(rider)
	do_mount_event.mount_ref=_ref(mount)
	
	_event.process(do_mount_event)
end



--_.do_toggle_mount=function()
--	-- wip
--	if is_mounting then
--		rider.mounted_on=_ref(mount)
--		mount.mounted_by=_ref(rider)
--	else -- unmount
--		rider.mounted_on=nil
--		mount.mounted_by=nil
--	end
--end



return _