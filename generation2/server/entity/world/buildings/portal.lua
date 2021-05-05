-- server

local _={}

_.entity_name="portal"

_.new=function(location, sprite)
	local result=BaseEntity.new(_.entity_name)
	
	
	if not sprite then
		result.sprite="portal"
	else
		result.sprite=sprite
	end
	
	
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
		return true
	end
	
	return false
end



return _