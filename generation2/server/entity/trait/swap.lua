-- global Swap
-- смена управляемой сущности

local _={}


-- с порталами нельзя
-- можно с подвижными сущностями (для начала)
_.can_swap_with=function(who,candidate)
	-- wip: как определить подвижную сущность?
	-- пока что не морочимся - можно свапать со всем.
	
	return true
end


-- 
_.pick_target=function(controlled_entity,player)
	local swap_range=10
	local swap_candidates=CollisionService.get_around(controlled_entity, swap_range)
	
	for k,candidate in pairs(swap_candidates) do
		if controlled_entity~=candidate then 
			if _.can_swap_with(controlled_entity, candidate) then
				return candidate
			end
		else
			-- not swap with self
			local a=1
		end
	end
	
	return nil
end

-- выполнить своп
_.do_swap=function(controlled_entity,target,player)
	if not target then return false end
	
	local target_ref=_ref(target)
	Player.attach(player, target_ref)
	
	return true
end





return _