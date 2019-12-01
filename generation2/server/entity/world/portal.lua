local _={}

_.entityName="portal"

_.new=function()
	local result=BaseEntity.new(_.entityName)
	
	result.sprite="portal"
	
	result.location="space"
	
	--todo: from sprite
	result.w=10
	result.h=9
	
	
	return result
end

-- target is this, actor is player
_.interact=function(actor,target)
	local levelName=target.location
	Player.gotoLevel(actor,levelName)
end



return _