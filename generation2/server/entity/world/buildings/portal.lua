-- server

local _={}

_.entity_name="portal"

_.new=function(location)
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="portal"
	
	if not location then
		result.location="space"
	else
		result.location=location
	end
	
	
	BaseEntity.init_bounds_from_sprite(result)
	
	
	return result
end

-- target is this, actor is player
_.interact=function(actor,target,player)
	local level_name=target.location
	
	if player then
		Player.gotoLevel(player,level_name)
	end
end



return _