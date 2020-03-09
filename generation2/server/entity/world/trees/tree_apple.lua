local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	-- todo: this should be pop in growable init from phase 1
	result.sprite="seed"
	result.planted_on=Pow.get_frame()
	result.grow_phases=
	{
			{
				sprite="seed",
				duration=_rnd(3000, 6000),
			},
			{
				sprite="tree_apple_1",
				duration=_rnd(600, 6000),
			},			
			{
				sprite="tree_apple_2",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_apple_3",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_apple_4",
				duration=_rnd(600, 6000),
			},
{
				sprite="tree_apple_5",
				duration=_rnd(600, 6000),
			},			
{
				sprite="tree_apple_6",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_apple_7",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_apple_8",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_apple_9",
				duration=_rnd(600, 6000),
			},
			{
				sprite="tree_apple_10",
				-- duration=_rnd(600, 6000),
			},
			-- todo: die cycle
	}


	-- todo: props of sprite, not entity?
	result.footX=15
	result.footY=46
	
	Growable.init(result)
	
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end



_.update_simulation=function(entity)
	-- log("tree update sim")
	
	-- todo: easy attach/detach traits
	Growable.update_simulation(entity)

		
end

return _