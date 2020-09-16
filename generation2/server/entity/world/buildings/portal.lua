-- server

local _={}

_.entity_name="portal"

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="portal"
	
	result.location="space"
	
	--todo: from sprite
	result.w=10
	result.h=9
	
	
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