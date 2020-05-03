local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="seed"
	result.planted_on=Pow.get_frame()
	
	local phase_duration_max=6000
	-- debug
	phase_duration_max=800
	result.grow_phases=
	{
			{
				-- todo: origin point for every sprite here
				sprite="seed",
				duration=_rnd(3000, phase_duration_max),
			},
			{
				sprite="birch_tree_1",
				duration=_rnd(600, phase_duration_max),
			},			
			{
				sprite="birch_tree_2",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="birch_tree_3",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="birch_tree_4",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="birch_tree_5",
--				duration=_rnd(600, phase_duration_max),
			},			
	}

	result.foot_x=8
	result.foot_y=15

	
	Growable.init(result)
	
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end

_.update_simulation=Growable.update_simulation
--_.update_simulation=function(entity)
--	Growable.update_simulation(entity)
--end


return _