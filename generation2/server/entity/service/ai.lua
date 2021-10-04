-- global Ai
local _entity_name='Ai'
local _=BaseEntity.new(_entity_name, true)

local _maxDistance=50

local _event=nil
_.load=function()
	_event=Pow.net.event
end

_.moveRandom=function(entity,max_distance)
	local maxDistance=max_distance
	
	if not maxDistance then
		maxDistance=_maxDistance
	end
	
	local random=Pow.lume.random
	local clamp=Pow.lume.clamp
	
	local current_x=entity.x+entity.foot_x
	local current_y=entity.y+entity.foot_y
	
	local dx=random(-maxDistance,maxDistance)
	local dy=random(-maxDistance,maxDistance)
	
	-- local world=CurrentWorld
	-- todo actual level size
	local max_x=4096
	local max_y=4096
	
	
	-- opt, some calc could be done once
	if current_x<300 then 
		dx=dx+random(50)
	end
	
	if current_y<300 then
		dy=dy+random(50)
	end
	
	if current_x>max_x-300 then 
		dx=dx-random(50)
	end
	
	if current_y>max_y-300 then
		dy=dy-random(50)
	end
	

	local nextXRaw=current_x+dx
	local nextYRaw=current_y+dy
	
--	log(_ets(entity))
	
--	log("ai moveRandom. dx:".._n(dx).." dy:".._n(dy)..
--		" nextXRaw:".._n(nextXRaw).." nextYRaw:".._n(nextYRaw)
--		)
	

	local border=64
	
	local min=0+border
	local max_x_final=max_x-border
	local max_y_final=max_y-border
	
	local nextX=clamp(nextXRaw,min,max_x_final)
	local nextY=clamp(nextYRaw,min,max_y_final)
	
	--log("after clamp nextX:".._n(nextX).." nextY:".._n(nextY))
	
	Movable.move_event(entity,nextX,nextY)
end






-- collisions are checked, do attack
local attack=function(actor,target)
	local damage=actor.attack_damage
	
	Hp.change(target,-damage)
end

-- return: обработано ли (была ли атака или ход).
_.update_combat=function(entity, is_enemy, options)
	
	
	local attack_only=options~=nil and options.attack_only
	
	-- detect target in melee range (collision check)
	local collsions=CollisionService.getEntityCollisions(entity)
	if collsions then
--		log("zombie melee action")
		for k,collision_entity in pairs(collsions) do
--			log("combat ai collision:".._ets(collision_entity))
			-- todo priority
			
			if is_enemy(entity,collision_entity) then
				attack(entity,collision_entity)
				return true
			end
		end
	else -- no collisions in melee range
		-- поиск цели и ходьба к ней
		
		if attack_only then
			return true
		end
		
		
--		log("zombie seek")
		-- todo: свойство сущности
		local seek_distance=45
		local collisions_seek=CollisionService.get_around(entity,seek_distance)
		
		for k,seek_entity in pairs(collisions_seek) do
			if is_enemy(entity,seek_entity) then
				-- attack(entity,seek_entity)
				
				-- todo: Entity.get_center()
				local attack_move_x=seek_entity.x+seek_entity.origin_x
				local attack_move_y=seek_entity.y+seek_entity.origin_y
				
--				log("see enemy:".._ets(seek_entity).." me:".._ets(entity))
				Movable.move_event(entity,attack_move_x,attack_move_y)
				
				return true
			end
		end
	end
	
	return false
end

return _