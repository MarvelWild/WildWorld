-- todo: separate apples from tree
local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	-- todo: this should be pop in growable init from phase 1
	result.sprite="seed"
	result.planted_on=Pow.get_frame()
	
	-- todo: genetics
	result.apples_per_season_current=0
	result.apples_per_season_max=_rnd(5,10)
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
				sprite="tree_apple_1",
				duration=_rnd(600, phase_duration_max),
			},			
			{
				sprite="tree_apple_2",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="tree_apple_3",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="tree_apple_4",
				duration=_rnd(600, phase_duration_max),
			},
{
				sprite="tree_apple_5",
				duration=_rnd(600, phase_duration_max),
			},			
{
				sprite="tree_apple_6",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="tree_apple_7",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="tree_apple_8",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="tree_apple_9",
				duration=_rnd(600, phase_duration_max),
			},
			{
				sprite="tree_apple_10",
				-- duration=_rnd(600, phase_duration_max),
			},
			-- todo: die cycle
	}


	-- todo: props of sprite, not entity?
	result.footX=15
	result.footY=46
	
	result.grow_apple_frame=0
	
	-- harvestable? inventory trait? think it later.
	-- where apples stored
	result.items={}
	
	Growable.init(result)
	
	
	BaseEntity.init_bounds_from_sprite(result)
	
	return result
end


local drop_item=function(entity,source)
	log("drop_item:".._ets(entity))

	--todo adjust to drop low
	entity.x=source.x+_rnd(-48,48)
	entity.y=source.y+_rnd(32,64)
	
	
	local event=Event.new("drop")
	event.entity=_ref(entity)
	event.target="level"
	event.level=source.level_name
	event.do_not_process_on_server=true
	
	-- Event.process(event)
	
	Db.add(entity)
end



_.update_simulation=function(entity)
	-- log("tree update sim")
	
	-- todo: easy attach/detach traits
	Growable.update_simulation(entity)
	
	-- wip test
	--todo: better define apple producing phases
	if entity.grow_phase_index==11 then
		
		
		local grow_frame=entity.grow_apple_frame
		local frame=_frm()
		if grow_frame>frame then return end
		
		if entity.apples_per_season_current >= entity.apples_per_season_max then
			return
		end
		
		entity.apples_per_season_current=entity.apples_per_season_current+1
		
		
		-- grow apples
		local items=entity.items
		local apple_count=#items
		local max_apples=7
		if apple_count<max_apples then
			log("apple grows")
			
			local new_apple=Apple.new();
			new_apple.level_name=entity.level_name
			table.insert(items,new_apple)
			
			
			-- 30 sec = 1800 frames
			entity.grow_apple_frame=frame+_rnd(1800,3600)
		end
		
		-- drop apples
		if apple_count>0 then
			local apple=table.pull_last(items)
			drop_item(apple,entity)
		end
	end
	
end

return _