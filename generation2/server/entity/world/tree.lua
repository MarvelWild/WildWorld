local _={}

_.entity_name="tree"

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	-- todo: this should be pop in growable init from phase 1
	result.sprite="seed"
	-- result.sprite="tree_apple_9"
	result.planted_on=Pow.get_frame()
	result.grow_phases=
	{
			{
				sprite="seed",
				duration=_rnd(3000, 6000),
			},
			{
				sprite="birch_tree_1",
				duration=_rnd(600, 6000),
			},			
			{
				sprite="birch_tree_2",
				duration=_rnd(600, 6000),
			},
			{
				sprite="birch_tree_3",
				duration=_rnd(600, 6000),
			},
			{
				sprite="birch_tree_4",
				duration=_rnd(600, 6000),
			},
			{
				sprite="birch_tree_5",
				-- duration=_rnd(600, 6000),
			},
			-- todo: die cycle
	}

	-- при достижении финальной фазы во что превратиться дальше
	-- result.growInto="tree"
	
	-- todo: props of sprite, not entity?
	result.footX=15
	result.footY=46
	
	
	--[[ тут можно сделать процедуры будущего - 
	например через 42 фрейма вызвать расти. 
	Минусы:
	может быть неактуально
	Плюсы: нет проверки каждый фрейм
	
	пусть пока что проверка будет, надо будет оптимизация - сделаю.
	
	]]--
	
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