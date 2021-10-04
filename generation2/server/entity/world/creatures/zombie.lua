-- server
local _={}

local _entity_name=Pow.currentFile()
_.entity_name=_entity_name

_.new=function()
	local result=BaseEntity.new(_.entity_name)
	
	result.sprite="zombie_1"
	
	BaseEntity.init_bounds_from_sprite(result)
	
	result.foot_x=3
	result.foot_y=14
	
	result.move_speed=7
	
	
	return result
end

local is_enemy=function(entity,other)
	-- сейчас все кроме др зомби
	
	if other.entity_name==_entity_name then
		return false
	end
		
	--todo: все живые
	if other.entity_name=="humanoid" then
		return true
	end
	
	return false
end

-- collisions are checked, do attack
local attack=function(actor,target)
	local damage=0.1
	target.hp=target.hp-damage
	
	ServerService.entity_updated(target)
end


-- entity=мы=зомби
local update_ai_combat=function(entity)
	-- todo: seek target, move to it
	
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


_.updateAi=function(entity)
	if update_ai_combat(entity) then return end
	
	-- todo: рандомно двигаться медленнее, преследовать быстрее
	AiService.moveRandom(entity)
end



--_.interact=Mountable.toggle_mount

return _