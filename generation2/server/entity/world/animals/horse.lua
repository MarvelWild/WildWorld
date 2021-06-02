local _={}

_.entity_name=Pow.currentFile()

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="horse_small"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=17
	result.foot_y=22
	
	result.mount_slots=
	{
		{
			x=21,
			y=16,
		},
		{
			x=10,
			y=16,
		},
	}
	
	Mountable.init(result)


	result.origin_x=17
	result.origin_y=16
	
	result.move_speed=28
	
	return result
end

_.updateAi=function(actor)
	if DebugFlag.horse_do_not_move then return end
	
	if not Mountable.is_mounted(actor) then
		-- todo: seek food if hungry
		
		local entities_can_see=CollisionService.get_around(actor,60)
		
		local food_can_see=Eater.get_edible(actor,entities_can_see)
		
		local chozen_food=Pow.lume.randomchoice(food_can_see)
		if chozen_food then
			log("see food:".._ets(chozen_food))
			
			Movable.move_event(actor,chozen_food.x,chozen_food.y)
		else
			log("see no food")
			
			-- todo: подойти к существу с наивысшей привязанностью
--			local max_bond_entity,bond_value=Bond.get_max_entity(actor)
			
--			if bond_value>0 then
				
--			end
			
			-- существо следует за тем к кому привязано
			-- wip split distance
			-- todo keep distance
			local nextX = max_bond_entity.x
			local nextY = max_bond_entity.y
			Movable.move_event(actor,nextX,nextY)

			AiService.moveRandom(actor)
		end
	else
		local mount_slots=actor.mount_slots
		
		local max_bond=0
		local max_bond_entity=nil
		
		for k,slot in pairs(mount_slots) do
			local other=_deref(slot.rider)
			local bond=Bond.get(actor,other)
			if bond>max_bond then 
				max_bond=bond 
				max_bond_entity=other
			end
		end
		
		if max_bond<1 then
			AiService.moveRandom(actor)
		end
		
	end
end


-- actor - humanoid
-- target - horse
local eat_from_hand=function(actor, target)

	Carrier.remove_from_hand(actor)
	log("horse fed")
	
	-- +удалить из мира яблоко
	-- +удалить из руки яблоко на клиенте - проверить
	-- +лошадь - увеличить привязанность к кормящему
	-- +лошадь - показать сердечко
	
	Bond.add(target,actor,1)
	
	local event=Event.new("creature_fed")
	event.target="level"
	event.level=actor.level_name
	event.do_not_process_on_server=true
	event.creature=_ref(target)
	Event.process(event)
end


-- с нами взаимодействует entity
-- actor: humanoid
-- target: horse
_.interact=function(actor, target)
	-- todo feed apple or
	-- Mountable.toggle_mount
	
	local hand_ref=actor.hand_slot
	if hand_ref then
		-- todo: описать группу съедобных для лошади
		if hand_ref.entity_name=="apple" then
			eat_from_hand(actor, target)
			return
		end
	end
		
	Mountable.toggle_mount(actor,target)
end




return _