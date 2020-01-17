--[[
	rider.mounted_on - reference
	mount.mounted_by - reference
]]--
local _={}

-- send event, handled by do_toggle_mount
_.toggle_mount=function(rider,mount)
	-- todo: checks can mount
	
	local is_mounting=rider.mounted_on==nil
	

	local do_mount_event=Event.new("do_mount")
	
	-- wip event
end

_.do_toggle_mount=function()
	-- wip
	if is_mounting then
		rider.mounted_on=_ref(mount)
		mount.mounted_by=_ref(rider)
	else -- unmount
		rider.mounted_on=nil
		mount.mounted_by=nil
	end
end



return _