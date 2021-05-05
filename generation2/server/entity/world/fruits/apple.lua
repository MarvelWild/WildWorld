local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite=_.entity_name
	result.is_item=true
	
	result.foot_x=1
	result.foot_y=2
	
	result.origin_x=1
	result.origin_y=1
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

--_.interact=function(player,target)
--	log("interact with:".._ets(target))
--end


return _