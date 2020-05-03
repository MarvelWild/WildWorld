local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="seed"
	result.planted_on=Pow.get_frame()
	local duration_max=2000
	
	-- todo: declarative way, define mass frames easily like sprites="orangee.*"
	result.grow_phases=
	{
			{
				sprite="seed",
				duration=_rnd(1000, duration_max),
			},
			{
				sprite="orangee1",
				duration=_rnd(600, duration_max),
			},
			{
				sprite="orangee2",
				duration=_rnd(600, duration_max),
			},
			{
				sprite="orangee3",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee4",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee5",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee6",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee7",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee8",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee9",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee10",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee11",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee12",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee13",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee14",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee15",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee16",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee17",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee18",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee19",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee20",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee21",
				duration=_rnd(600, duration_max),
			},			
			{
				sprite="orangee22",
				-- duration=_rnd(600, 6000),
			},
			-- todo: die cycle
	}
	
	result.foot_x=7
	result.foot_y=30
	Growable.init(result)
	

	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end


_.update_simulation=function(entity)
	Growable.update_simulation(entity)
end

return _