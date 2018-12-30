-- global Standing
local _={}

_.name="Standing"

-- from,to:entity
-- returns -10 to 10
_.get=function(from, to)
	if to.entity=="Pantera" then return -10 end
	
	return 0
end


return _