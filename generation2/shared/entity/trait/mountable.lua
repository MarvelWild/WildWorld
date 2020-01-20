-- shared

local _={}

_.do_mount=function(rider,mount)
	log("shared mountable: do_toggle_mount")
	
	-- todo: check mount.mounted_by for consistency too
	
	if mount==nil then
		-- unmount
		local prev_mount_ref=rider.mounted_on
		if prev_mount_ref~=nil then
			rider.mounted_on=nil
			mount.mounted_by=nil
		else
			log("warn: was not mounted but received unmount")
		end
	else --mount
		if rider.mounted_on~=nil then
			log("warn: was mounted but received mount")
		else
			-- we can save reference for client too
			rider.mounted_on=_ref(mount)
			mount.mounted_by=_ref(rider)
		end
	end
end

return _