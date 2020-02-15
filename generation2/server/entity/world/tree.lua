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
	
	result.planted_on=Pow.get_frame()
	
	
	
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

--[[ ex seed


local _={}

_.entity_name="seed"


_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="seed"
	
	local frame=Pow.get_frame()
	result.plantedOn=frame

	-- entity_name
	result.growInto="tree"
	
	local secondsToGrow=love.math.random(5,20)
	result.growOn=secondsToGrow*Config.serverFps+frame
	
	return result
end

local doGrow=function(entity)
	-- todo: выделить логику трансформации сущности 1 в 2
	local growInto=entity.growInto
	
	local entityCode=Entity.getCodeByName(growInto)
	local newInstance=entityCode.new()
	
	-- todo: use foot point
	newInstance.x=entity.x-newInstance.footX
	newInstance.y=entity.y-newInstance.footY
	
	local level_name=entity.level_name
	Db.add(newInstance,level_name)
	
	Db.remove(entity,level_name)
end


_.update_simulation=function(entity)
	local frame=Pow.get_frame()
	local growOn=entity.growOn
	if growOn~=nil then
		if frame>growOn then
			doGrow(entity)
		else
			log("not time to grow, now "..frame..", will grow on:"..growOn)
		end
	else
		log("seed wont grow:")
		
	end
	
	
end





return _
]]--