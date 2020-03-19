local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="seed"
	result.planted_on=Pow.get_frame()
	result.grow_phases=
	{
			{
				sprite="seed",
				duration=_rnd(3000, 6000),
			},
			{
				sprite="tree_fir_1",
				duration=_rnd(600, 6000),
			},			
			{
				sprite="tree_fir_2",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_fir_3",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_fir_4",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_fir_5",
				-- duration=_rnd(600, 6000),
			},
			-- todo: die cycle
	}
	
	result.footX=16
	result.footY=60
	Growable.init(result)
	

	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end


_.update_simulation=function(entity)
	Growable.update_simulation(entity)
end

return _