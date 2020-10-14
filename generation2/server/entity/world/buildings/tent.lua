local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	
	-- todo: auto gen
	result.location="tent_inside"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

_.interact=function(actor,target,player)
	log("tent interact")
	local level_name=target.location
	
	if player then
		Player.gotoLevel(player,level_name)
	end
end


return _