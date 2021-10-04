local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="pegasus"
	BaseEntity.init_bounds_from_sprite(result)
	
-- todo: from gen1, what it was for? editor placing...	flip point.
--	result.originX=27
--	result.originY=31	
	
	result.foot_x=22
	result.foot_y=46	
	
	result.mount_slots=
	{
		{
			x=27,
			y=31,
			rider=nil,
		},
	}
	
	Mountable.init(result)
	
	return result
end

_.updateAi=function(entity)
--	log("pegasus update ai")
	
	-- todo: enable after mount
	-- Ai.moveRandom(entity)

end

_.interact=function(actor,target)
	Mountable.toggle_mount(actor,target)
end



return _