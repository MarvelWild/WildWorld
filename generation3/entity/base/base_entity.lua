

local _={}

_.new=function(name)
	local data={}
	
	data.name=name
	data.x=0
	data.y=0
	
	return data
end


return _