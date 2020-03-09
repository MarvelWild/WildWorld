-- todo: separate apples from tree
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
	
	-- harvestable? inventory trait? think it later.
	-- where apples stored
	result.items={}
	
	Growable.init(result)
	
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end


local drop_item=function(entity)
	log("drop_item:".._ets(entity))
	-- wip emit event
	-- wip read gen1 drop
end



_.update_simulation=function(entity)
	-- log("tree update sim")
	
	-- todo: easy attach/detach traits
	Growable.update_simulation(entity)
	
	-- wip test
	if entity.grow_phase_index==11 then
		-- grow apples
		local items=entity.items
		local apple_count=#items
		local max_apples=7
		if apple_count<max_apples then
			log("apple grows")
			
			local new_apple=1;
			table.insert(items,new_apple)
		end
		
		-- drop apples
		-- todo: random
		if apple_count>0 then
			local apple=table.pull_last(items)
			drop_item(apple)
		end
	end
	
end

return _